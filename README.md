# Robot Framework Tests for TodoMVC React App

This repository contains comprehensive Robot Framework test automation for the [TodoMVC React application](https://todomvc.com/examples/react/dist/).

## Overview

The test suite provides complete coverage of TodoMVC functionality including:
- Adding, editing, and deleting todo items
- Completing and uncompleting todos
- Filtering todos (All/Active/Completed)
- Batch operations (Toggle All, Clear Completed)
- Todo counter validation
- Complex workflow scenarios

## Project Structure

```
rf-test/
├── resources/
│   └── todomvc_keywords.robot    # Reusable keywords and page objects
├── tests/
│   └── todomvc_smoke_tests.robot # Comprehensive test suite
├── .github/
│   └── workflows/
│       └── robot-tests.yml       # CI/CD pipeline
├── requirements.txt              # Python dependencies
└── README.md                     # This file
```

## Prerequisites

- Python 3.8+
- Chrome browser (for Selenium tests)
- ChromeDriver (automatically managed by CI)

## Installation

1. Clone the repository:
```bash
git clone https://github.com/pbexe/rf-test.git
cd rf-test
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

## Running Tests

### Run All Tests
```bash
robot tests/
```

### Run Tests with Custom Output Directory
```bash
robot --outputdir results tests/
```

### Run Tests with Specific Tags
```bash
# Run only basic functionality tests
robot --include basic tests/

# Run only filter-related tests  
robot --include filter tests/

# Run complex workflow tests
robot --include complex tests/
```

### Run Tests in Different Browser
```bash
robot --variable BROWSER:Firefox tests/
```

### Run Tests Headless (for CI)
```bash
robot --variable BROWSER:headlesschrome tests/
```

## Test Categories

The test suite is organized with the following tags:

- **basic**: Fundamental operations (add, complete, delete single items)
- **multiple**: Operations on multiple items
- **filter**: Filtering functionality (All/Active/Completed)
- **toggle**: Batch toggle operations
- **edit**: Todo editing functionality
- **counter**: Todo counter validation
- **complex**: Multi-step workflow scenarios
- **empty**: Empty state handling

## Keywords Documentation

### Core Keywords (todomvc_keywords.robot)

- `Open TodoMVC Application`: Opens browser and navigates to TodoMVC
- `Add Todo Item [text]`: Adds a new todo with specified text
- `Complete Todo Item [text]`: Marks todo as completed
- `Delete Todo Item [text]`: Deletes a todo item
- `Edit Todo Item [old_text] [new_text]`: Edits existing todo
- `Filter Todos By [All|Active|Completed]`: Applies filter
- `Toggle All Todos`: Toggles all todos between completed/active
- `Clear Completed Todos`: Removes all completed todos
- `Verify Todo Count Is [number]`: Validates todo counter

## Continuous Integration

The project includes a GitHub Actions workflow that:

- Runs on every push to main/develop branches
- Runs on pull requests to main branch
- Can be triggered manually
- Installs dependencies and Chrome browser
- Executes all tests
- Uploads test results and reports as artifacts
- Publishes test results in the workflow summary

### CI Artifacts

After each test run, the following artifacts are available:
- `robot-framework-results`: Complete test output including HTML reports
- Test results summary in the workflow run summary

## Browser Support

Currently configured for Chrome, but can be easily extended to support:
- Firefox: `robot --variable BROWSER:Firefox tests/`
- Edge: `robot --variable BROWSER:Edge tests/`
- Headless Chrome: `robot --variable BROWSER:headlesschrome tests/`

## Extending Tests

### Adding New Test Cases

1. Add new test cases to `tests/todomvc_smoke_tests.robot`
2. Use existing keywords from `resources/todomvc_keywords.robot`
3. Add appropriate tags for organization
4. Follow existing naming conventions

### Adding New Keywords

1. Add keywords to `resources/todomvc_keywords.robot`
2. Include proper documentation
3. Use appropriate waiting strategies
4. Follow Robot Framework best practices

## Test Results

Test results are generated in multiple formats:
- `output.xml`: Machine-readable test results
- `report.html`: High-level test report
- `log.html`: Detailed execution log with screenshots

## Troubleshooting

### Common Issues

1. **ChromeDriver not found**: Ensure ChromeDriver is in PATH or use webdrivermanager
2. **Timeouts**: Increase timeout values in keywords if needed
3. **Element not found**: Check if page loaded completely before interaction

### Debug Mode

Run tests with increased logging:
```bash
robot --loglevel DEBUG --outputdir debug_results tests/
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add tests following existing patterns
4. Ensure all tests pass
5. Submit a pull request

## License

This project is open source and available under the MIT License.