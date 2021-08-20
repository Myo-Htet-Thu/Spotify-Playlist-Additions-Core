git config user.name "${GITHUB_ACTOR}"
git config user.email "patrick.christie.dev@gmail.com"
git config --global push.followTags true
git remote set-url origin https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}
last_commit_msg=$(git log -1 --pretty=format:"%s")

echo "Detected commit '$last_commit_msg'"

case "$last_commit_msg" in
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