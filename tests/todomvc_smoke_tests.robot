*** Settings ***
Documentation       Comprehensive smoke tests for TodoMVC React application
Resource            ../resources/todomvc_keywords.robot
Suite Setup         Open TodoMVC Application
Suite Teardown      Close TodoMVC Application
Test Setup          Reload Page
Test Tags           smoke

*** Test Cases ***
Add Single Todo Item
    [Documentation]    Test adding a single todo item
    [Tags]    add    basic
    Add Todo Item    Buy groceries
    Verify Todo Item Exists    Buy groceries
    Verify Todo Count Is    1

Add Multiple Todo Items
    [Documentation]    Test adding multiple todo items
    [Tags]    add    multiple
    Add Todo Item    Buy groceries
    Add Todo Item    Walk the dog
    Add Todo Item    Read a book
    Verify Todo Item Exists    Buy groceries
    Verify Todo Item Exists    Walk the dog
    Verify Todo Item Exists    Read a book
    Verify Todo Count Is    3

Complete Single Todo Item
    [Documentation]    Test completing a single todo item
    [Tags]    complete    basic
    Add Todo Item    Buy groceries
    Add Todo Item    Walk the dog
    Complete Todo Item    Buy groceries
    Verify Todo Item Is Completed    Buy groceries
    Verify Todo Item Is Active    Walk the dog
    Verify Todo Count Is    1

Complete Multiple Todo Items
    [Documentation]    Test completing multiple todo items
    [Tags]    complete    multiple
    Add Todo Item    Buy groceries
    Add Todo Item    Walk the dog
    Add Todo Item    Read a book
    Complete Todo Item    Buy groceries
    Complete Todo Item    Read a book
    Verify Todo Item Is Completed    Buy groceries
    Verify Todo Item Is Completed    Read a book
    Verify Todo Item Is Active    Walk the dog
    Verify Todo Count Is    1

Uncomplete Todo Item
    [Documentation]    Test uncompleting a completed todo item
    [Tags]    uncomplete
    Add Todo Item    Buy groceries
    Complete Todo Item    Buy groceries
    Verify Todo Item Is Completed    Buy groceries
    Uncomplete Todo Item    Buy groceries
    Verify Todo Item Is Active    Buy groceries
    Verify Todo Count Is    1

Delete Single Todo Item
    [Documentation]    Test deleting a single todo item
    [Tags]    delete    basic
    Add Todo Item    Buy groceries
    Add Todo Item    Walk the dog
    Delete Todo Item    Buy groceries
    Verify Todo Item Does Not Exist    Buy groceries
    Verify Todo Item Exists    Walk the dog
    Verify Todo Count Is    1

Delete Multiple Todo Items
    [Documentation]    Test deleting multiple todo items
    [Tags]    delete    multiple
    Add Todo Item    Buy groceries
    Add Todo Item    Walk the dog
    Add Todo Item    Read a book
    Delete Todo Item    Buy groceries
    Delete Todo Item    Read a book
    Verify Todo Item Does Not Exist    Buy groceries
    Verify Todo Item Does Not Exist    Read a book
    Verify Todo Item Exists    Walk the dog
    Verify Todo Count Is    1

Edit Todo Item
    [Documentation]    Test editing an existing todo item
    [Tags]    edit
    Add Todo Item    Buy groceries
    Edit Todo Item    Buy groceries    Buy organic groceries
    Verify Todo Item Does Not Exist    Buy groceries
    Verify Todo Item Exists    Buy organic groceries
    Verify Todo Count Is    1

Toggle All Todos Complete
    [Documentation]    Test toggling all todos to completed
    [Tags]    toggle    complete
    Add Todo Item    Buy groceries
    Add Todo Item    Walk the dog
    Add Todo Item    Read a book
    Toggle All Todos
    Verify Todo Item Is Completed    Buy groceries
    Verify Todo Item Is Completed    Walk the dog
    Verify Todo Item Is Completed    Read a book
    Verify Todo Count Is    0

Toggle All Todos Back To Active
    [Documentation]    Test toggling all todos from completed back to active
    [Tags]    toggle    active
    Add Todo Item    Buy groceries
    Add Todo Item    Walk the dog
    Toggle All Todos
    Verify Todo Count Is    0
    Toggle All Todos
    Verify Todo Item Is Active    Buy groceries
    Verify Todo Item Is Active    Walk the dog
    Verify Todo Count Is    2

Clear Completed Todos
    [Documentation]    Test clearing all completed todos
    [Tags]    clear    completed
    Add Todo Item    Buy groceries
    Add Todo Item    Walk the dog
    Add Todo Item    Read a book
    Complete Todo Item    Buy groceries
    Complete Todo Item    Read a book
    Clear Completed Todos
    Verify Todo Item Does Not Exist    Buy groceries
    Verify Todo Item Does Not Exist    Read a book
    Verify Todo Item Exists    Walk the dog
    Verify Todo Count Is    1

Filter All Todos
    [Documentation]    Test filtering to show all todos
    [Tags]    filter    all
    Add Todo Item    Buy groceries
    Add Todo Item    Walk the dog
    Complete Todo Item    Buy groceries
    Filter Todos By    All
    ${visible_count}=    Get Visible Todo Items Count
    Should Be Equal As Numbers    ${visible_count}    2
    Verify Todo Item Exists    Buy groceries
    Verify Todo Item Exists    Walk the dog

Filter Active Todos Only
    [Documentation]    Test filtering to show only active todos
    [Tags]    filter    active
    Add Todo Item    Buy groceries
    Add Todo Item    Walk the dog
    Add Todo Item    Read a book
    Complete Todo Item    Buy groceries
    Filter Todos By    Active
    ${visible_count}=    Get Visible Todo Items Count
    Should Be Equal As Numbers    ${visible_count}    2
    Verify Todo Item Exists    Walk the dog
    Verify Todo Item Exists    Read a book

Filter Completed Todos Only
    [Documentation]    Test filtering to show only completed todos
    [Tags]    filter    completed
    Add Todo Item    Buy groceries
    Add Todo Item    Walk the dog
    Add Todo Item    Read a book
    Complete Todo Item    Buy groceries
    Complete Todo Item    Walk the dog
    Filter Todos By    Completed
    ${visible_count}=    Get Visible Todo Items Count
    Should Be Equal As Numbers    ${visible_count}    2
    Verify Todo Item Exists    Buy groceries
    Verify Todo Item Exists    Walk the dog

Todo Counter Updates Correctly
    [Documentation]    Test that the todo counter updates correctly
    [Tags]    counter
    Add Todo Item    Buy groceries
    Verify Todo Count Is    1
    Add Todo Item    Walk the dog
    Verify Todo Count Is    2
    Complete Todo Item    Buy groceries
    Verify Todo Count Is    1
    Complete Todo Item    Walk the dog
    Verify Todo Count Is    0
    Uncomplete Todo Item    Buy groceries
    Verify Todo Count Is    1

Empty State Handling
    [Documentation]    Test behavior when no todos exist
    [Tags]    empty
    # Start with empty list, verify no elements visible
    ${visible_count}=    Get Visible Todo Items Count
    Should Be Equal As Numbers    ${visible_count}    0
    # Add and then delete to verify clean state
    Add Todo Item    Temporary todo
    Delete Todo Item    Temporary todo
    ${visible_count}=    Get Visible Todo Items Count
    Should Be Equal As Numbers    ${visible_count}    0

Complex Workflow Test
    [Documentation]    Test a complex workflow combining multiple operations
    [Tags]    complex    workflow
    # Add multiple todos
    Add Todo Item    Morning exercise
    Add Todo Item    Check emails
    Add Todo Item    Attend meeting
    Add Todo Item    Lunch break
    Verify Todo Count Is    4
    
    # Complete some todos
    Complete Todo Item    Morning exercise
    Complete Todo Item    Check emails
    Verify Todo Count Is    2
    
    # Edit a todo
    Edit Todo Item    Attend meeting    Attend important meeting
    
    # Add one more todo
    Add Todo Item    Review documents
    Verify Todo Count Is    3
    
    # Filter to show only active
    Filter Todos By    Active
    ${visible_count}=    Get Visible Todo Items Count
    Should Be Equal As Numbers    ${visible_count}    3
    
    # Clear completed todos
    Filter Todos By    All
    Clear Completed Todos
    Verify Todo Count Is    3
    
    # Complete all remaining
    Toggle All Todos
    Verify Todo Count Is    0