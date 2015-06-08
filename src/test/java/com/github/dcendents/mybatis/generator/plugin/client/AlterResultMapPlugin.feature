Feature: AlterResultMapPlugin

  Scenario: Should be invalid without any property configured
    When the validate method is called
    Then validate should return false
     And validate should have produced 2 warnings
  
  
  Scenario: Should be invalid with only the table name configured
    Given the table name is properly configured
    When the validate method is called
    Then validate should return false
     And validate should have produced 1 warnings

  
  Scenario: Should be invalid with only the interfaces configured
    Given the result map id is properly configured
    When the validate method is called
    Then validate should return false
     And validate should have produced 1 warnings


  Scenario: Should be valid when both properties are configured
    Given the table name is properly configured
      And the result map id is properly configured
    When the validate method is called
    Then validate should return true
     And validate should have produced 0 warnings

  
  Scenario: Should not modify the result map attribute if the table does not match
    Given the table name is properly configured
      And the result map id is properly configured
      And the element has a result map attribute
      But the introspected table is a different table
    When the validate method is called
     And the renameResultMapAttribute for element is called
    Then the element attributes size will be 1
     And the result map attribute's name at position 0 won't have changed
     And the result map attribute's value at position 0 won't have changed

  
  Scenario: Should modify the result map attribute when the table matches
    Given the table name is properly configured
      And the result map id is properly configured
      And the element has a random attribute
      And the element has a result map attribute
      And the introspected table is the right table
    When the validate method is called
     And the renameResultMapAttribute for element is called
    Then the element attributes size will be 2
     And the result map attribute's name at position 1 won't have changed
     And the result map attribute's value at position 1 will have been modified

  
  Scenario: Should handle an element with an empty attribute list
    Given the table name is properly configured
      And the result map id is properly configured
      And the introspected table is the right table
    When the validate method is called
     And the renameResultMapAttribute for element is called
    Then the element attributes size will be 0

  
  Scenario: Should not modify the result map annotation if the table does not match
    Given the table name is properly configured
      And the result map id is properly configured
      And the method has a result map annotation
      But the introspected table is a different table
    When the validate method is called
     And the renameResultMapAttribute for method is called
    Then the method annotations size will be 1
     And the annotation at position 0 won't have changed

  
  Scenario: Should modify the result map annotation when the table matches
    Given the table name is properly configured
      And the result map id is properly configured
      And the method has a random annotation
      And the method has a result map annotation
      And the introspected table is the right table
    When the validate method is called
     And the renameResultMapAttribute for method is called
    Then the method annotations size will be 2
     And the annotation at position 1 will have been modified

  
  Scenario: Should handle a method with an empty annotation list
    Given the table name is properly configured
      And the result map id is properly configured
      And the introspected table is the right table
    When the validate method is called
     And the renameResultMapAttribute for method is called
    Then the method annotations size will be 0

  
  Scenario: Should modify the result map attribute of method SelectByExampleWithoutBLOBs for element
    Given the table name is properly configured
      And the result map id is properly configured
      And the element has a result map attribute
      And the introspected table is the right table
    When the validate method is called
     And the SelectByExampleWithoutBLOBs method for element is called
    Then the generated method return value will be true
     And the element attributes size will be 1
     And the result map attribute's name at position 0 won't have changed
     And the result map attribute's value at position 0 will have been modified

  
  Scenario: Should modify the result map attribute of method SelectByExampleWithBLOBs for element
    Given the table name is properly configured
      And the result map id is properly configured
      And the element has a result map attribute
      And the introspected table is the right table
    When the validate method is called
     And the SelectByExampleWithBLOBs method for element is called
    Then the generated method return value will be true
     And the element attributes size will be 1
     And the result map attribute's name at position 0 won't have changed
     And the result map attribute's value at position 0 will have been modified

  
  Scenario: Should modify the result map attribute of method SelectByPrimaryKey for element
    Given the table name is properly configured
      And the result map id is properly configured
      And the element has a result map attribute
      And the introspected table is the right table
    When the validate method is called
     And the SelectByPrimaryKey method for element is called
    Then the generated method return value will be true
     And the element attributes size will be 1
     And the result map attribute's name at position 0 won't have changed
     And the result map attribute's value at position 0 will have been modified

  
  Scenario: Should modify the result map attribute of method SelectAll for element
    Given the table name is properly configured
      And the result map id is properly configured
      And the element has a result map attribute
      And the introspected table is the right table
    When the validate method is called
     And the SelectAll method for element is called
    Then the generated method return value will be true
     And the element attributes size will be 1
     And the result map attribute's name at position 0 won't have changed
     And the result map attribute's value at position 0 will have been modified

  
  Scenario: Should modify the result map annotation of method SelectByExampleWithBLOBs for interface
    Given the table name is properly configured
      And the result map id is properly configured
      And the method has a result map annotation
      And the introspected table is the right table
    When the validate method is called
     And the SelectByExampleWithBLOBs method for interface is called
    Then the generated method return value will be true
     And the method annotations size will be 1
     And the annotation at position 0 will have been modified

  
  Scenario: Should modify the result map annotation of method SelectByExampleWithoutBLOBs for interface
    Given the table name is properly configured
      And the result map id is properly configured
      And the method has a result map annotation
      And the introspected table is the right table
    When the validate method is called
     And the SelectByExampleWithoutBLOBs method for interface is called
    Then the generated method return value will be true
     And the method annotations size will be 1
     And the annotation at position 0 will have been modified

  
  Scenario: Should modify the result map annotation of method SelectByPrimaryKey for interface
    Given the table name is properly configured
      And the result map id is properly configured
      And the method has a result map annotation
      And the introspected table is the right table
    When the validate method is called
     And the SelectByPrimaryKey method for interface is called
    Then the generated method return value will be true
     And the method annotations size will be 1
     And the annotation at position 0 will have been modified

  
  Scenario: Should modify the result map annotation of method SelectAll for interface
    Given the table name is properly configured
      And the result map id is properly configured
      And the method has a result map annotation
      And the introspected table is the right table
    When the validate method is called
     And the SelectAll method for interface is called
    Then the generated method return value will be true
     And the method annotations size will be 1
     And the annotation at position 0 will have been modified

  
  Scenario: Should modify the result map annotation of method SelectByExampleWithBLOBs for class
    Given the table name is properly configured
      And the result map id is properly configured
      And the method has a result map annotation
      And the introspected table is the right table
    When the validate method is called
     And the SelectByExampleWithBLOBs method for class is called
    Then the generated method return value will be true
     And the method annotations size will be 1
     And the annotation at position 0 will have been modified

  
  Scenario: Should modify the result map annotation of method SelectByExampleWithoutBLOBs for class
    Given the table name is properly configured
      And the result map id is properly configured
      And the method has a result map annotation
      And the introspected table is the right table
    When the validate method is called
     And the SelectByExampleWithoutBLOBs method for class is called
    Then the generated method return value will be true
     And the method annotations size will be 1
     And the annotation at position 0 will have been modified

  
  Scenario: Should modify the result map annotation of method SelectByPrimaryKey for class
    Given the table name is properly configured
      And the result map id is properly configured
      And the method has a result map annotation
      And the introspected table is the right table
    When the validate method is called
     And the SelectByPrimaryKey method for class is called
    Then the generated method return value will be true
     And the method annotations size will be 1
     And the annotation at position 0 will have been modified

  
  Scenario: Should modify the result map annotation of method SelectAll for class
    Given the table name is properly configured
      And the result map id is properly configured
      And the method has a result map annotation
      And the introspected table is the right table
    When the validate method is called
     And the SelectAll method for class is called
    Then the generated method return value will be true
     And the method annotations size will be 1
     And the annotation at position 0 will have been modified

  
  