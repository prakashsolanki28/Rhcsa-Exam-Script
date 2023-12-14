#!/bin/bash

check_yum_repo() {
    # Check if the repository file exists
    repo_file="/etc/yum.repos.d/myrepo.repo"
    if [ -f "$repo_file" ]; then
        # Check if the [AppStream] section exists
        if grep -q '\[AppStream\]' "$repo_file"; then
            appstream_section=1
        else
            appstream_section=0
        fi

        # Check if the [BaseOS] section exists
        if grep -q '\[BaseOS\]' "$repo_file"; then
            baseos_section=1
        else
            baseos_section=0
        fi

        # Check if the [AppStream] section contains the desired settings
        if grep -qE '^\s*baseurl\s*=\s*file:///dvd/AppStream\s*$' "$repo_file" &&
           grep -qE '^\s*gpgcheck\s*=\s*0\s*$' "$repo_file" &&
           grep -qE '^\s*enabled\s*=\s*1\s*$' "$repo_file"; then
            appstream_settings=1
        else
            appstream_settings=0
        fi

        # Check if the [BaseOS] section contains the desired settings
        if grep -qE '^\s*baseurl\s*=\s*file:///dvd/BaseOS\s*$' "$repo_file" &&
           grep -qE '^\s*gpgcheck\s*=\s*0\s*$' "$repo_file" &&
           grep -qE '^\s*enabled\s*=\s*1\s*$' "$repo_file"; then
            baseos_settings=1
        else
            baseos_settings=0
        fi

        # Check if both sections and settings match
        if [ $appstream_section -eq 1 ] && [ $baseos_section -eq 1 ] &&
           [ $appstream_settings -eq 1 ] && [ $baseos_settings -eq 1 ]; then
            return 0  # Content matches (true)
        else
            return 1  # Content does not match (false)
        fi
    else
        return 1  # Repository file does not exist (false)
    fi
}

# Call the function and capture its return value
check_yum_repo
result=$?

# Check the return value and print the appropriate message
if [ $result -eq 0 ]; then
    echo "Content matches."
else
    echo "Content does not match."
fi

