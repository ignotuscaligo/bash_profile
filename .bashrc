# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		echo " : [${BRANCH}${STAT}]"
	else
		echo ""
	fi
}

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

CLR_ATTRIB="\[$(tput sgr0)\]"
SPACE="\[\033[38;5;15m\] $CLR_ATTRIB"
COLON="\[\033[38;5;22m\]:$CLR_ATTRIB"
DIVIDER="$SPACE$COLON$SPACE"

# initialize
PROFILE=""
# 'time'
PROFILE="$PROFILE\[\033[38;5;94m\]\t$CLR_ATTRIB"
# ' : hostname'
#PROFILE="$PROFILE$DIVIDER\[\033[38;5;100m\]\h$CLR_ATTRIB"
# ' : directory'
PROFILE="$PROFILE$DIVIDER\[\033[38;5;154m\]\w$CLR_ATTRIB"
# 'parse_git_branch '
PROFILE="$PROFILE\[\033[38;5;62m\]\`parse_git_branch\`$CLR_ATTRIB"
# '\n"
PROFILE="$PROFILE\[\033[38;5;15m\]\n$CLR_ATTRIB"
# '> '
PROFILE="$PROFILE\[\033[38;5;226m\]>$CLR_ATTRIB$SPACE"

export PS1=$PROFILE

