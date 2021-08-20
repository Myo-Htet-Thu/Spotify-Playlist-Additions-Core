git config user.name "${GITHUB_ACTOR}"
git config user.email "patrick.christie.dev@gmail.com"
git config --global push.followTags true
git remote set-url origin https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}
last_commit_msg=$(git log -1 --pretty=format:"%s")
last_merged_branch=$(git log --merges -n 1)

echo "Detected commit '$last_commit_msg'"

if [[ "$last_commit_msg" == *"Bump version"* ]]
then
    echo "Version already bumped. Ignoring";
    exit;
fi

case "$last_merged_branch" in
    *"[MAJOR]"*)
        echo "Detected MAJOR"; bump2version major;;
    *"[MINOR]"*)
        echo "Detected MINOR"; bump2version minor;;
    *"[PATCH]"*)
        echo "Detected PATCH"; bump2version patch;;
    *)
        echo "Ignoring"; exit;;

esac

git push origin HEAD:develop