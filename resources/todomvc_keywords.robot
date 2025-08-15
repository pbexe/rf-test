*** Settings ***
Documentation       Keywords for TodoMVC React application
Library             SeleniumLibrary
Library             Collections

*** Variables ***
${BASE_URL}             https://todomvc.com/examples/react/dist/
${BROWSER}              Chrome
${TODO_INPUT}           css:.new-todo
${TODO_LIST}            css:.todo-list
${TODO_ITEM}            css:.todo-list li
${TOGGLE_ALL}           css:.toggle-all
${CLEAR_COMPLETED}      css:.clear-completed
${TODO_COUNT}           css:.todo-count
${FILTER_ALL}           xpath://a[contains(text(), 'All')]
${FILTER_ACTIVE}        xpath://a[contains(text(), 'Active')]  
${FILTER_COMPLETED}     xpath://a[contains(text(), 'Completed')]

*** Keywords ***
Open TodoMVC Application
    [Documentation]    Opens the TodoMVC React application
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Page Contains Element    ${TODO_INPUT}

Close TodoMVC Application
    [Documentation]    Closes the browser
    Close Browser

Add Todo Item
    [Documentation]    Adds a new todo item
    [Arguments]    ${todo_text}
    Input Text    ${TODO_INPUT}    ${todo_text}
    Press Keys    ${TODO_INPUT}    RETURN
    Wait Until Page Contains    ${todo_text}

Get Todo Count
    [Documentation]    Gets the current todo count from the counter
    ${count_text}=    Get Text    ${TODO_COUNT}
    ${count}=    Get Regexp Matches    ${count_text}    \\d+
    RETURN    ${count}[0]

Complete Todo Item
    [Documentation]    Marks a todo item as completed by its text
    [Arguments]    ${todo_text}
    ${item_xpath}=    Set Variable    xpath://li[contains(., '${todo_text}')]//input[@type='checkbox']
    Click Element    ${item_xpath}
    Wait Until Element Is Visible    xpath://li[contains(., '${todo_text}') and contains(@class, 'completed')]

Uncomplete Todo Item
    [Documentation]    Marks a completed todo item as active by its text
    [Arguments]    ${todo_text}
    ${item_xpath}=    Set Variable    xpath://li[contains(., '${todo_text}') and contains(@class, 'completed')]//input[@type='checkbox']
    Click Element    ${item_xpath}
    Wait Until Element Is Not Visible    xpath://li[contains(., '${todo_text}') and contains(@class, 'completed')]

Delete Todo Item
    [Documentation]    Deletes a todo item by hovering and clicking the delete button
    [Arguments]    ${todo_text}
    ${item_xpath}=    Set Variable    xpath://li[contains(., '${todo_text}')]
    Mouse Over    ${item_xpath}
    ${delete_xpath}=    Set Variable    xpath://li[contains(., '${todo_text}')]//button[@class='destroy']
    Click Element    ${delete_xpath}
    Wait Until Page Does Not Contain    ${todo_text}

Edit Todo Item
    [Documentation]    Edits an existing todo item
    [Arguments]    ${old_text}    ${new_text}
    ${item_xpath}=    Set Variable    xpath://li[contains(., '${old_text}')]//label
    Double Click Element    ${item_xpath}
    ${edit_input}=    Set Variable    xpath://li[contains(., '${old_text}')]//input[@class='edit']
    Wait Until Element Is Visible    ${edit_input}
    Clear Element Text    ${edit_input}
    Input Text    ${edit_input}    ${new_text}
    Press Keys    ${edit_input}    RETURN
    Wait Until Page Contains    ${new_text}
    Wait Until Page Does Not Contain    ${old_text}

Toggle All Todos
    [Documentation]    Toggles all todos between completed and active
    Click Element    ${TOGGLE_ALL}

Clear Completed Todos
    [Documentation]    Clears all completed todos
    Click Element    ${CLEAR_COMPLETED}

Filter Todos By
    [Documentation]    Filters todos by the given filter type
    [Arguments]    ${filter_type}
    IF    '${filter_type}' == 'All'
        Click Element    ${FILTER_ALL}
    ELSE IF    '${filter_type}' == 'Active'
        Click Element    ${FILTER_ACTIVE}
    ELSE IF    '${filter_type}' == 'Completed'
        Click Element    ${FILTER_COMPLETED}
    ELSE
        Fail    Unknown filter type: ${filter_type}
    END

Verify Todo Item Exists
    [Documentation]    Verifies that a todo item exists on the page
    [Arguments]    ${todo_text}
    Wait Until Page Contains    ${todo_text}

Verify Todo Item Does Not Exist
    [Documentation]    Verifies that a todo item does not exist on the page
    [Arguments]    ${todo_text}
    Wait Until Page Does Not Contain    ${todo_text}

Verify Todo Item Is Completed
    [Documentation]    Verifies that a todo item is marked as completed
    [Arguments]    ${todo_text}
    Wait Until Element Is Visible    xpath://li[contains(., '${todo_text}') and contains(@class, 'completed')]

Verify Todo Item Is Active
    [Documentation]    Verifies that a todo item is not completed
    [Arguments]    ${todo_text}
    Wait Until Element Is Visible    xpath://li[contains(., '${todo_text}') and not(contains(@class, 'completed'))]

Verify Todo Count Is
    [Documentation]    Verifies the todo count matches expected value
    [Arguments]    ${expected_count}
    ${actual_count}=    Get Todo Count
    Should Be Equal As Numbers    ${actual_count}    ${expected_count}

Get Visible Todo Items Count
    [Documentation]    Returns the number of currently visible todo items
    ${elements}=    Get WebElements    ${TODO_ITEM}
    ${count}=    Get Length    ${elements}
    RETURN    ${count}