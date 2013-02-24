# -*- mode: sh;-*-

TRASH=$ZDOTDIR/.trash

move_to_trash ()
{
	FOLDER=$TRASH/$PWD

	for element in $@; do
		if [ -e $element ]; then
			echo "Deleting $element..."
			mkdir -p $FOLDER/${element:h}
			mv -f $element $FOLDER/${element:h}/.
		fi
	done
}

list_deleted_elements ()
{
	FOLDER=$TRASH/$PWD

	if [ -d $FOLDER ]; then
			ls -lad $(find $FOLDER -maxdepth 1 ! -wholename $FOLDER) | sed "s:$FOLDER/::"
	else
		echo "Nothing found in trash."
	fi
}

undelete_from_trash ()
{
	FOLDER=$TRASH/$PWD

	for element in $@; do
		if [ -e $FOLDER/$element ]; then
			echo "Getting back $element..."
			mkdir -p ${element:h}
			mv $FOLDER/$element .
			rmdir --ignore-fail-on-non-empty -p $FOLDER 
		else
			echo "Not found in trash: $element"
		fi
	done
}

alias delete='move_to_trash'
alias undelete='undelete_from_trash'
alias lsdeleted='list_deleted_elements'

alias cdtrash='cd $TRASH/$PWD'
alias sotrash='cd ${PWD/$TRASH/}'

hash -d trash=$TRASH
