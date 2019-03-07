#!/bin/bash
set -e


#deploy apps (skills). See: https://snips.gitbook.io/documentation/console/deploying-your-skills
snips-template render

#goto skill directory
cd /var/lib/snips/skills

#start with a clear skill directory
rm -rf *

#download required skills from git
for url in $(awk '$1=="url:" {print $2}' /usr/share/snips/assistant/Snipsfile.yaml); do
	git clone $url
done

#be shure we are still in the skill directory
cd /var/lib/snips/skills

#run setup.sh for each skill.
find . -maxdepth 1 -type d -print0 | while IFS= read -r -d '' dir; do
	cd "$dir"
	if [ -f setup.sh ]; then
		echo "Run setup.sh in "$dir
		#run the scrips always with bash
		bash ./setup.sh
	fi
	cd /var/lib/snips/skills
done

#go back to root directory
cd /
# Edit config for skills
python3 edit_skills.py

#skill deployment is done

#start Snips' Automatic Speech Recognition service
snips-asr -vvv 2> /var/log/snips-asr.log &
snips_asr_pid=$!

#start Snips-dialogue service
snips-dialogue -vvv 2> /var/log/snips-dialogue.log  &
snips_dialogue_pid=$!

#start Snips hotword service
snips-hotword -vvv 2> /var/log/snips-hotword.log &
snips_hotword_pid=$!

#start Snips Natural Language Understanding service
snips-nlu -vvv 2> /var/log/snips-nlu.log &
snips_nlu_pid=$!

#start Snips Skill service
snips-skill-server -vvv 2> /var/log/snips-skill-server &
snips_skill_server_pid=$!

#start Snips TTS service
snips-tts -vvv 2> /var/log/snips-tts.log &
snips_tts_pid=$!

#start the snips audio server without playback and microphone
snips-audio-server -vvv 2> /var/log/snips-audio-server.log &
snips_audio_server_pid=$!

snips-watch -vvv
