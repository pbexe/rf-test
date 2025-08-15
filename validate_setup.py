#!/usr/bin/env python3
"""
Simple validation script to check Robot Framework setup
"""
import sys
import subprocess
from pathlib import Path

def check_file_exists(filepath, description):
    """Check if a file exists and print status"""
    if Path(filepath).exists():
        print(f"✓ {description}: {filepath}")
        return True
    else:
        print(f"✗ {description} missing: {filepath}")
        return False

def check_robot_framework():
    """Check if Robot Framework can be imported"""
    try:
        subprocess.run([sys.executable, "-c", "import robot; print('✓ Robot Framework can be imported')"], 
                      check=True, capture_output=True, text=True)
        return True
    except subprocess.CalledProcessError:
        print("✗ Robot Framework not available (expected in CI environment)")
        return False

def main():
    print("Robot Framework Test Setup Validation")
    print("=" * 40)
    
    # Check required files
    files_ok = True
    files_ok &= check_file_exists("resources/todomvc_keywords.robot", "Resource file")
    files_ok &= check_file_exists("tests/todomvc_smoke_tests.robot", "Test file")
    files_ok &= check_file_exists(".github/workflows/robot-tests.yml", "CI workflow")
    files_ok &= check_file_exists("requirements.txt", "Requirements file")
    files_ok &= check_file_exists("README.md", "Documentation")
    files_ok &= check_file_exists(".gitignore", "Git ignore file")
    
    # Check Robot Framework (optional in this environment)
    rf_ok = check_robot_framework()
    
    print("\nValidation Summary:")
    print(f"File structure: {'✓ Complete' if files_ok else '✗ Missing files'}")
    print(f"Robot Framework: {'✓ Available' if rf_ok else '! Will be installed in CI'}")
    
    if files_ok:
        print("\n🎉 Setup is complete! Tests will run in CI environment.")
        return 0
    else:
        print("\n❌ Setup incomplete - missing required files")
        return 1

if __name__ == "__main__":
    sys.exit(main())