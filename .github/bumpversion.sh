last_merged_branch=$(git log --merges -n 1)
branch_name="${last_merged_branch##*$'\n'}"

echo "Detected branch name '$branch_name'"

case "$branch_name" in
    *[IGNORE]* ) echo "Ignoring" && exit;;
    *[MAJOR]* ) bump2version major;;
    *[MAJOR]* ) bump2version minor;;
    *[MAJOR]* ) bump2version patch;;
esac