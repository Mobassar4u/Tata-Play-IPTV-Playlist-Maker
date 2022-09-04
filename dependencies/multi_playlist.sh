            cd ..
            cat "$branch_name.json" > userDetails.json
            python3 utils.py ${playlist_args}
            git clone ${gist_url}
            rm ${dir}/TataPlayPlaylist.m3u
            mv *.m3u ${dir}/
            cd ${dir}
            git add .
            git commit --amend -m "Playlist has been updated"
            git push -f
