git pull

last_merged_branch=$(git log --merges -n 1 develop)
branch_name="${last_merged_branch##*$'\n'}"

echo "Detected branch name '$branch_name'"

case "$branch_name" in
    *[IGNORE]* ) echo "Ignoring" && exit;;
    *[MAJOR]* ) bump2version major;;
    *[MAJOR]* ) bump2version minor;;
    *[MAJOR]* ) bump2version patch;;
esac

git_refs_url=$(jq .repository.git_refs_url $GITHUB_EVENT_PATH | tr -d '"' | sed 's/{\/sha}//g')

git_refs_response=$(
curl -s -X POST $git_refs_url \
-H "Authorization: token $GITHUB_TOKEN" \
-d @- << EOF

{
  "ref": "refs/tags/$new",
  "sha": "$commit"
}
EOF
)

git_ref_posted=$( echo "${git_refs_response}" | jq .ref | tr -d '"' )

echo "::debug::${git_refs_response}"
if [ "${git_ref_posted}" = "refs/tags/${new}" ]; then
  exit 0
else
  echo "::error::Tag was not created properly."
  exit 1
fi