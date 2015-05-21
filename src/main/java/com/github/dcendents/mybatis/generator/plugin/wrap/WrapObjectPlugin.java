package com.github.dcendents.mybatis.generator.plugin.wrap;

import static org.mybatis.generator.internal.util.StringUtility.stringHasValue;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

import org.apache.commons.lang3.StringUtils;
import org.mybatis.generator.api.IntrospectedColumn;
import org.mybatis.generator.api.IntrospectedTable;
import org.mybatis.generator.api.PluginAdapter;
import org.mybatis.generator.api.dom.java.Field;
import org.mybatis.generator.api.dom.java.FullyQualifiedJavaType;
import org.mybatis.generator.api.dom.java.JavaVisibility;
import org.mybatis.generator.api.dom.java.Method;
import org.mybatis.generator.api.dom.java.TopLevelClass;

@NoArgsConstructor
public class WrapObjectPlugin extends PluginAdapter {
	public static final String TABLE_NAME = "fullyQualifiedTableName";
	public static final String OBJECT_CLASS = "objectClass";
	public static final String OBJECT_FIELD_NAME = "objectFieldName";
	public static final String INCLUDES = "includes";
	public static final String EXCLUDES = "excludes";

	private String tableName;
	private Class<?> objectClass;

	@Getter(AccessLevel.PACKAGE)
	private Set<String> includes = new HashSet<>();
	@Getter(AccessLevel.PACKAGE)
	private Set<String> excludes = new HashSet<>();

	@Getter(AccessLevel.PACKAGE)
	private String objectFieldName;

	@Getter(AccessLevel.PACKAGE)
	private Set<String> gettersToWrap = new HashSet<>();
	@Getter(AccessLevel.PACKAGE)
	private Set<String> settersToWrap = new HashSet<>();

	@Override
	public boolean validate(List<String> warnings) {
		tableName = properties.getProperty(TABLE_NAME);
		String objectClassName = properties.getProperty(OBJECT_CLASS);

		String warning = "Property %s not set for plugin %s";
		if (!stringHasValue(tableName)) {
			warnings.add(String.format(warning, TABLE_NAME, this.getClass().getSimpleName()));
		}
		if (!stringHasValue(objectClassName)) {
			warnings.add(String.format(warning, OBJECT_CLASS, this.getClass().getSimpleName()));
		} else {
			try {
				objectClass = Class.forName(objectClassName);
			} catch (ClassNotFoundException ex) {
				warnings.add(String.format("Could not load class %s in plugin %s", objectClassName, this.getClass()
						.getSimpleName()));
			}
		}

		String includesString = properties.getProperty(INCLUDES);
		if (stringHasValue(includesString)) {
			for (String include : includesString.split(",")) {
				includes.add(include.trim());
			}
		}

		String excludesString = properties.getProperty(EXCLUDES);
		if (stringHasValue(excludesString)) {
			for (String exclude : excludesString.split(",")) {
				excludes.add(exclude.trim());
			}
		}

		objectFieldName = properties.getProperty(OBJECT_FIELD_NAME);
		if (!stringHasValue(objectFieldName) && objectClass != null) {
			objectFieldName = StringUtils.uncapitalize(objectClass.getSimpleName());
		}

		return stringHasValue(tableName) && objectClass != null;
	}

	private boolean tableMatches(IntrospectedTable introspectedTable) {
		return tableName.equals(introspectedTable.getFullyQualifiedTableNameAtRuntime());
	}

	@Override
	public boolean modelBaseRecordClassGenerated(TopLevelClass topLevelClass, IntrospectedTable introspectedTable) {
		if (tableMatches(introspectedTable)) {
			FullyQualifiedJavaType type = new FullyQualifiedJavaType(objectClass.getName());
			Field field = new Field(objectFieldName, type);
			field.setVisibility(JavaVisibility.PROTECTED);
			field.setInitializationString(String.format("new %s()", objectClass.getSimpleName()));

			field.addJavaDocLine("/**");
			field.addJavaDocLine(" * This field was generated by MyBatis Generator.");
			field.addJavaDocLine(" * This field corresponds to the wrapped object.");
			field.addJavaDocLine(" *");
			field.addJavaDocLine(" * @mbggenerated");
			field.addJavaDocLine(" */");

			topLevelClass.addField(field);
			topLevelClass.addImportedType(type);
		}

		return true;
	}

	@Override
	public boolean modelFieldGenerated(Field field, TopLevelClass topLevelClass, IntrospectedColumn introspectedColumn,
			IntrospectedTable introspectedTable, ModelClassType modelClassType) {
		if (tableMatches(introspectedTable) && wrapField(field)) {
			topLevelClass.addImportedType(field.getType());
			return false;
		}

		return true;
	}

	private boolean wrapField(Field field) {
		if (includes.contains(field.getName()) || (includes.isEmpty() && !excludes.contains(field.getName()))) {
			return objectClassHasFieldGetter(field);
		}

		return false;
	}

	private boolean objectClassHasFieldGetter(Field field) {
		java.lang.reflect.Method getter = null;

		FullyQualifiedJavaType type = field.getType();
		String prefix = type.isPrimitive() && type.getShortName().equals("boolean") ? "is" : "get";

		String capitalized = StringUtils.capitalize(field.getName());
		String getterName = prefix + capitalized;
		String setterName = "set" + capitalized;

		try {
			getter = objectClass.getDeclaredMethod(getterName);
			gettersToWrap.add(getterName);
			settersToWrap.add(setterName);
		} catch (NoSuchMethodException ex) {
		}

		return getter != null;
	}

	@Override
	public boolean modelGetterMethodGenerated(Method method, TopLevelClass topLevelClass,
			IntrospectedColumn introspectedColumn, IntrospectedTable introspectedTable, ModelClassType modelClassType) {
		if (tableMatches(introspectedTable) && gettersToWrap.contains(method.getName())) {
			method.getBodyLines().clear();
			method.addBodyLine(String.format("return this.%s.%s();", objectFieldName, method.getName()));
		}

		return true;
	}

	@Override
	public boolean modelSetterMethodGenerated(Method method, TopLevelClass topLevelClass,
			IntrospectedColumn introspectedColumn, IntrospectedTable introspectedTable, ModelClassType modelClassType) {
		if (tableMatches(introspectedTable) && settersToWrap.contains(method.getName())) {
			method.getBodyLines().clear();
			method.addBodyLine(String.format("this.%s.%s(%s);", objectFieldName, method.getName(), method
					.getParameters().get(0).getName()));
		}

		return true;
	}

}