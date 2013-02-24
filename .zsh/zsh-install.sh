#!/bin/sh
# This script was generated using Makeself 2.1.5

CRCsum="892806987"
MD5="7693a1a6a3059d119117a97087f0941d"
TMPROOT=${TMPDIR:=/tmp}

label="joerg ZSH config files"
script="zsh"
scriptargs="./install.zsh MAGIC"
targetdir="tmp.8fF7ppTk5s"
filesizes="43691"
keep=n

print_cmd_arg=""
if type printf > /dev/null; then
    print_cmd="printf"
elif test -x /usr/ucb/echo; then
    print_cmd="/usr/ucb/echo"
else
    print_cmd="echo"
fi

unset CDPATH

MS_Printf()
{
    $print_cmd $print_cmd_arg "$1"
}

MS_Progress()
{
    while read a; do
	MS_Printf .
    done
}

MS_diskspace()
{
	(
	if test -d /usr/xpg4/bin; then
		PATH=/usr/xpg4/bin:$PATH
	fi
	df -kP "$1" | tail -1 | awk '{print $4}'
	)
}

MS_dd()
{
    blocks=`expr $3 / 1024`
    bytes=`expr $3 % 1024`
    dd if="$1" ibs=$2 skip=1 obs=1024 conv=sync 2> /dev/null | \
    { test $blocks -gt 0 && dd ibs=1024 obs=1024 count=$blocks ; \
      test $bytes  -gt 0 && dd ibs=1 obs=1024 count=$bytes ; } 2> /dev/null
}

MS_Help()
{
    cat << EOH >&2
Makeself version 2.1.5
 1) Getting help or info about $0 :
  $0 --help   Print this message
  $0 --info   Print embedded info : title, default target directory, embedded script ...
  $0 --lsm    Print embedded lsm entry (or no LSM)
  $0 --list   Print the list of files in the archive
  $0 --check  Checks integrity of the archive
 
 2) Running $0 :
  $0 [options] [--] [additional arguments to embedded script]
  with following options (in that order)
  --confirm             Ask before running embedded script
  --noexec              Do not run embedded script
  --keep                Do not erase target directory after running
			the embedded script
  --nox11               Do not spawn an xterm
  --nochown             Do not give the extracted files to the current user
  --target NewDirectory Extract in NewDirectory
  --tar arg1 [arg2 ...] Access the contents of the archive through the tar command
  --                    Following arguments will be passed to the embedded script
EOH
}

MS_Check()
{
    OLD_PATH="$PATH"
    PATH=${GUESS_MD5_PATH:-"$OLD_PATH:/bin:/usr/bin:/sbin:/usr/local/ssl/bin:/usr/local/bin:/opt/openssl/bin"}
	MD5_ARG=""
    MD5_PATH=`exec <&- 2>&-; which md5sum || type md5sum`
    test -x "$MD5_PATH" || MD5_PATH=`exec <&- 2>&-; which md5 || type md5`
	test -x "$MD5_PATH" || MD5_PATH=`exec <&- 2>&-; which digest || type digest`
    PATH="$OLD_PATH"

    MS_Printf "Verifying archive integrity..."
    offset=`head -n 404 "$1" | wc -c | tr -d " "`
    verb=$2
    i=1
    for s in $filesizes
    do
		crc=`echo $CRCsum | cut -d" " -f$i`
		if test -x "$MD5_PATH"; then
			if test `basename $MD5_PATH` = digest; then
				MD5_ARG="-a md5"
			fi
			md5=`echo $MD5 | cut -d" " -f$i`
			if test $md5 = "00000000000000000000000000000000"; then
				test x$verb = xy && echo " $1 does not contain an embedded MD5 checksum." >&2
			else
				md5sum=`MS_dd "$1" $offset $s | eval "$MD5_PATH $MD5_ARG" | cut -b-32`;
				if test "$md5sum" != "$md5"; then
					echo "Error in MD5 checksums: $md5sum is different from $md5" >&2
					exit 2
				else
					test x$verb = xy && MS_Printf " MD5 checksums are OK." >&2
				fi
				crc="0000000000"; verb=n
			fi
		fi
		if test $crc = "0000000000"; then
			test x$verb = xy && echo " $1 does not contain a CRC checksum." >&2
		else
			sum1=`MS_dd "$1" $offset $s | CMD_ENV=xpg4 cksum | awk '{print $1}'`
			if test "$sum1" = "$crc"; then
				test x$verb = xy && MS_Printf " CRC checksums are OK." >&2
			else
				echo "Error in checksums: $sum1 is different from $crc"
				exit 2;
			fi
		fi
		i=`expr $i + 1`
		offset=`expr $offset + $s`
    done
    echo " All good."
}

UnTAR()
{
    tar $1vf - 2>&1 || { echo Extraction failed. > /dev/tty; kill -15 $$; }
}

finish=true
xterm_loop=
nox11=n
copy=none
ownership=y
verbose=n

initargs="$@"

while true
do
    case "$1" in
    -h | --help)
	MS_Help
	exit 0
	;;
    --info)
	echo Identification: "$label"
	echo Target directory: "$targetdir"
	echo Uncompressed size: 496 KB
	echo Compression: gzip
	echo Date of packaging: Sun Feb 24 23:39:23 CET 2013
	echo Built with Makeself version 2.1.5 on 
	echo Build command was: "/usr/bin/makeself \\
    \"--gzip\" \\
    \"/home/joerg/tmp/tmp.8fF7ppTk5s\" \\
    \"/home/joerg/.zsh/zsh-install.sh\" \\
    \"joerg ZSH config files\" \\
    \"zsh\" \\
    \"./install.zsh\" \\
    \"MAGIC\""
	if test x$script != x; then
	    echo Script run after extraction:
	    echo "    " $script $scriptargs
	fi
	if test x"" = xcopy; then
		echo "Archive will copy itself to a temporary location"
	fi
	if test x"n" = xy; then
	    echo "directory $targetdir is permanent"
	else
	    echo "$targetdir will be removed after extraction"
	fi
	exit 0
	;;
    --dumpconf)
	echo LABEL=\"$label\"
	echo SCRIPT=\"$script\"
	echo SCRIPTARGS=\"$scriptargs\"
	echo archdirname=\"tmp.8fF7ppTk5s\"
	echo KEEP=n
	echo COMPRESS=gzip
	echo filesizes=\"$filesizes\"
	echo CRCsum=\"$CRCsum\"
	echo MD5sum=\"$MD5\"
	echo OLDUSIZE=496
	echo OLDSKIP=405
	exit 0
	;;
    --lsm)
cat << EOLSM
No LSM.
EOLSM
	exit 0
	;;
    --list)
	echo Target directory: $targetdir
	offset=`head -n 404 "$0" | wc -c | tr -d " "`
	for s in $filesizes
	do
	    MS_dd "$0" $offset $s | eval "gzip -cd" | UnTAR t
	    offset=`expr $offset + $s`
	done
	exit 0
	;;
	--tar)
	offset=`head -n 404 "$0" | wc -c | tr -d " "`
	arg1="$2"
	shift 2
	for s in $filesizes
	do
	    MS_dd "$0" $offset $s | eval "gzip -cd" | tar "$arg1" - $*
	    offset=`expr $offset + $s`
	done
	exit 0
	;;
    --check)
	MS_Check "$0" y
	exit 0
	;;
    --confirm)
	verbose=y
	shift
	;;
	--noexec)
	script=""
	shift
	;;
    --keep)
	keep=y
	shift
	;;
    --target)
	keep=y
	targetdir=${2:-.}
	shift 2
	;;
    --nox11)
	nox11=y
	shift
	;;
    --nochown)
	ownership=n
	shift
	;;
    --xwin)
	finish="echo Press Return to close this window...; read junk"
	xterm_loop=1
	shift
	;;
    --phase2)
	copy=phase2
	shift
	;;
    --)
	shift
	break ;;
    -*)
	echo Unrecognized flag : "$1" >&2
	MS_Help
	exit 1
	;;
    *)
	break ;;
    esac
done

case "$copy" in
copy)
    tmpdir=$TMPROOT/makeself.$RANDOM.`date +"%y%m%d%H%M%S"`.$$
    mkdir "$tmpdir" || {
	echo "Could not create temporary directory $tmpdir" >&2
	exit 1
    }
    SCRIPT_COPY="$tmpdir/makeself"
    echo "Copying to a temporary location..." >&2
    cp "$0" "$SCRIPT_COPY"
    chmod +x "$SCRIPT_COPY"
    cd "$TMPROOT"
    exec "$SCRIPT_COPY" --phase2 -- $initargs
    ;;
phase2)
    finish="$finish ; rm -rf `dirname $0`"
    ;;
esac

if test "$nox11" = "n"; then
    if tty -s; then                 # Do we have a terminal?
	:
    else
        if test x"$DISPLAY" != x -a x"$xterm_loop" = x; then  # No, but do we have X?
            if xset q > /dev/null 2>&1; then # Check for valid DISPLAY variable
                GUESS_XTERMS="xterm rxvt dtterm eterm Eterm kvt konsole aterm"
                for a in $GUESS_XTERMS; do
                    if type $a >/dev/null 2>&1; then
                        XTERM=$a
                        break
                    fi
                done
                chmod a+x $0 || echo Please add execution rights on $0
                if test `echo "$0" | cut -c1` = "/"; then # Spawn a terminal!
                    exec $XTERM -title "$label" -e "$0" --xwin "$initargs"
                else
                    exec $XTERM -title "$label" -e "./$0" --xwin "$initargs"
                fi
            fi
        fi
    fi
fi

if test "$targetdir" = "."; then
    tmpdir="."
else
    if test "$keep" = y; then
	echo "Creating directory $targetdir" >&2
	tmpdir="$targetdir"
	dashp="-p"
    else
	tmpdir="$TMPROOT/selfgz$$$RANDOM"
	dashp=""
    fi
    mkdir $dashp $tmpdir || {
	echo 'Cannot create target directory' $tmpdir >&2
	echo 'You should try option --target OtherDirectory' >&2
	eval $finish
	exit 1
    }
fi

location="`pwd`"
if test x$SETUP_NOCHECK != x1; then
    MS_Check "$0"
fi
offset=`head -n 404 "$0" | wc -c | tr -d " "`

if test x"$verbose" = xy; then
	MS_Printf "About to extract 496 KB in $tmpdir ... Proceed ? [Y/n] "
	read yn
	if test x"$yn" = xn; then
		eval $finish; exit 1
	fi
fi

MS_Printf "Uncompressing $label"
res=3
if test "$keep" = n; then
    trap 'echo Signal caught, cleaning up >&2; cd $TMPROOT; /bin/rm -rf $tmpdir; eval $finish; exit 15' 1 2 3 15
fi

leftspace=`MS_diskspace $tmpdir`
if test $leftspace -lt 496; then
    echo
    echo "Not enough space left in "`dirname $tmpdir`" ($leftspace KB) to decompress $0 (496 KB)" >&2
    if test "$keep" = n; then
        echo "Consider setting TMPDIR to a directory with more free space."
   fi
    eval $finish; exit 1
fi

for s in $filesizes
do
    if MS_dd "$0" $offset $s | eval "gzip -cd" | ( cd "$tmpdir"; UnTAR x ) | MS_Progress; then
		if test x"$ownership" = xy; then
			(PATH=/usr/xpg4/bin:$PATH; cd "$tmpdir"; chown -R `id -u` .;  chgrp -R `id -g` .)
		fi
    else
		echo
		echo "Unable to decompress $0" >&2
		eval $finish; exit 1
    fi
    offset=`expr $offset + $s`
done
echo

cd "$tmpdir"
res=0
if test x"$script" != x; then
    if test x"$verbose" = xy; then
		MS_Printf "OK to execute: $script $scriptargs $* ? [Y/n] "
		read yn
		if test x"$yn" = x -o x"$yn" = xy -o x"$yn" = xY; then
			eval $script $scriptargs $*; res=$?;
		fi
    else
		eval $script $scriptargs $*; res=$?
    fi
    if test $res -ne 0; then
		test x"$verbose" = xy && echo "The program '$script' returned an error code ($res)" >&2
    fi
fi
if test "$keep" = n; then
    cd $TMPROOT
    /bin/rm -rf $tmpdir
fi
eval $finish; exit $res
� ��*Q�=ic۶���
TVJ)/$uXv�<u��I�g�d��K�HH�$X��-;��;���m��Im,3 �`P�u��?�l7�����|g�{�V���4ۭv�^�	��=ҹ�>��iDȽ��,]�w����9rcw�����omn^=�[�b�[0���v�i����?i���Ц����N�ڹb�������b7i�֟�����c���M����(���Z���g��s�u�?����Cb�N���"dȣ8	�c�Y��#Fn��S���'�s�~�J>��C�lo�˔��ߡȂ9D�'�b�k��u�?`q���9���xc�a���v�s;�O�{���������\*��RK���_sn�;���Z��J�S~n�ܘ�t!Ƙ������N�;��눊���7�s��=o��[[k�_���~�s�߫��;z�w��2c����	�Ǽ/��V�.��O�����Ue����&�@�<�3��܀T~L0��]���T3��̨�/�AR���9�i��'�#$UU�U�H1��K�0!ư���2q�j�0�R�<�o�V���Ux⺎�8�r�=0v=
���
çg�1i���s��gB=5+��5�ۅ3O0-����)C� i�d�����a��/0<��g,��4���5C�8D�qH�G�,a�](cH]����?��4���xS0g�1ݼI��W�bVO���z
�x�ӗp5C�D:kz��9�gUَ,��m�� dt/�/ `�H�@a���M�(�v��<���'����^k�lV�7��k��*���H���@�M����?�A���;���������Z��+�1�>�������n������b�@7��������v��X�����q�AO?�y�Kw�;�����'#c�����OG�ѐ����n�4�~�Qluv7um#5�'b.��9:O�&�(�Β��d�}�I�H
�# 	O�Cp�AU�R�.��b����Y�u}5s4!�F��g�q=t=�1 i�G�Ě�p��V+�DYd!�/~O;g}��Ö��K:Qb�_���w�6o�P����,�Ƿ�*[We#o�Ro�,�XLo�SoE<U����k����$�����_�n�������f{������ `g!�b2��F�l���kY�\t������o@[{�ߤ��r?��x�E����y���������r�8.�=�99Ә�22�FF�ݛj}�*��êj�`ثU/��a�R�������ef�f�W�\v7�������}��^����)�x���z�Fj�sJ��H	pnA�c�FR�tZ�E7C�[P�{#-�����H�W�|��Gǯ/�s��b,+��X)g��pi���"`ifּlR.���f)&��|ҥ�8>����\��q�z��ڹ��`��];׽݇]�E��/R�_�W��O����������7����U����f$?�w`���,X�r�N�ߗ�
�9�o���j��Wg��'��Y7�"擏��Z����>�/|�����#�Z�W$�Y�ў��{��&�㡥�9��:�B��i��xܫ��W���zc1R_땕��f���$�O��6:����k�e�K��G=y�y&�n�]���~�������}�?(�۝���[����n��aC�x1�nl�Ґ�=�t��>@7b�<%�as�G=<�-£�hs��Úyt������X�	T�УS�-'P 솘��nQ����:�<$į"$�,R
��,If���t��"�9sTb�/I�h6�EJP�����'���f��p�c��,�|;,៎X��D^b1(��1ҋ�]�q��ҥ�#7�==�5�w�w$0Ω�0��ϋ8�{�0���Փã�����1�xn�L�͎����~r��_?�w�g�~(sr�*=�J�8mLX��u:�
&.�ےYO{��h��-�tǍ`l&�(|K��[YSLS�M���r�"�v�0�
�r�hVc`��YNs6�R�V�n�t;Ko�t$�Q�N��R�,����Y���!K���?���j�t�ƥ�x��\�������!#/����b
Cd���|�4r��%�@s��a$݇,�+#�W;
��
�0�F9���(X�S�C���% �D"҉C:�x��r�ޢ��
��'"���>d�"�q�Ta�mE̎I&�E�TJ]�"3r(^���b�^R5%Jņ:�#4]��>��P�cb�Q�]6;G��&�e��ow1��W�=>�\��������R�8�pH-b���{淚lX���F$�d7sܳ��aV�h��������p���9��2M,�kC�%�{W�P��6�����\Ƀ*�T�ص�F
��X�fĠr��r"���o����U���4d��xM��9t������%\yW����o��&�F��a�����@�i �)�		ME����o����R�ME��͔;�U���; ���2R�ј5֚b-�X�	Hl��Sg��0)�x��E&�Èa�V́����p>�y����/cR �DY�)ES�7���4��Kh���i⢱Ѥ�]nE�ς"y� G����F�`��F<�2&��$th�]D4(t�h@�ٳl�i���&	1DP����������
h��.��F��'�P�H����陡��g0G�W��e��~Dq�Ҳ1�<5�_9$�B'�J��g��b�3f���?��+�`P=8���t�bP�U/8B#�qcd� ��Ӟ�7���ô�%(T��
y�4.D������ ��/b:R��u��k���p�yH�P>�	,�*�TR4��=D2 �VD3g@�n3�&FHa��X�o Iw���D]�4+�BىT��$ sz@8�Q,*Z�J�`���F)�7C���S�.��Mʅj--�W��چ6�S��Xc"6쩮��? �l���an�$�:� ױ�f
��"��(��E%�@a�	k���.�kֶb8V־ڌ���h��4���J֪cs7pd�pjo��*�Lh㰤s,D˞�Df�h6�#��qՠ�b�(��[T�L������ta��.�a�g��������������(}@nSMԶ��`1��W����k�⟒=?+	mҟ�d��f���iMoy'4r� ױS�&,zn�x�|p�NM46'�u�ӂeLZ�R_plv(J2�]�a�b�`Ie����y���["_�`�ߴ7��:������9���.�7{�{��.,�	�m�.,pq䆂T�t[�R��%&�Ξ�O��DWB�d����;Q�5y�U�o7�FiR�u�jOY�F�/����;/ �f������T�
�Bz�*5����H2�������^QG�Y�5�?T���sR!�mp��&&Zw�B'��A�ct�P��z���Q��_�:�U�a�{O~y����]#�rAxI��;#�=�A�8up:�k�0�az��F�\�rh���W�*1����M�o�>��	,��d����.�V�}�7D��eBƿ���.����@3I���$PSfq �<����K��$7����|��	LjB�V��	L�y��w�90�q'mJh�`����:��L����أB	�G�XC��U�������<��?�޷J�hb�N�B�-ߥ��4�1s��<�=�-�̹$n!t�ra�^��H;��l��K"�d���*��y��)v�ws{�R�g(qqIs�Y���ٜ<UO�n9��� ����#�I��@��|%#�P�cW��>�o�k"�7/h��S] �F��JP> 4�ʗ�d�,�O�tY{aXuhh&r�~$��RMA@5���S՜������K����T�A9���,_��B�цR�E���to\%FAG`H,����H�JM`̍0�#`��DE�������[P2�<�#�S�p��8r_)k=���b=����u�SNH�o�I��A��{IP#.|r�)�y&_�q� %H"�zB���ś����{�k(Ćn��nPF�u��uǝ�ێ��RўMc���Q����ƓPt�|g��E�Bڵ�SPr���=E�@3�X�J�����ѫ�g��.��~�e�cY��锢�*U�[��>t�������Z��������?������?|��P�������?a¬��U������9������I�ȇ��s1,yy����%�םj^W8��iQ<,W������H�Q�֥&R*ΨWY�Q��Rz�Z��xE���ق@��@�k�B7J��EԁGQ:)�Fе�W(�q11��0Kݺ�ز��6ؙv�Ȇ}�T�F����C4�Sα,�H_�"�9���9�_m8�`j`V�"_�.G4%��!��ȇ��AF�8�K�J�v��<����)����tn���X�ć���C=k�'EK����M+��4���v�X���@�G��l�S�owHw�@p������w�!����ro�DLY{���Y�W*k1�{��r���Pd�Q�%��w|Gj�ss���U���h�`���$D�� I��Ț����r=�ξ��+�f���eڿz�u���>��[Gz6<:��T���9-��ҏˇ�7�/�#]mޒdƿ눥�^I���
�Q;V�V�;�ԂX���_�"���_�$�nV�5�\곭���[.�-;�����KA�p;�[��rcH)W;��dK/X^�0ps�2�dl��w���[�P����i�n Ω/c��!g*�yS�)���Y<�y)�^&��]��ǻ����K�@���Yx�{}�ge���(6$}G�'��{-{��b��o/���vk^���k�_]����A��e��ӡ�4��`��d�NX�Y
Z�RKVj?�d��!�E*kUn��9dU�VN�T���s��#�����y���튫Fx����V��"X^*�A��?8G���^�K��z&��m��
I��9��D.{̍���� Zm�3��Cm �|�ٺ�`�����үK�_����p��s�$�Eֆܿ��o4��ĺ���vZ[�?��������`��1���ϕ�6ihZ�SqB����x)�DoxJ�x���E> j�|cy,��!��]���2H��>:�q���"��(�*�I�21����(�ߕO�U!'T���B�O���ؠS����c���!��4	���Ddh�B#M��ᡝ**��3U7�j�G�v����g��hhow^��?}���?�Jx��<�	8�b�[
4�V��N���_x�-p����3��[k�oe�!7U��Ӣ~������Fvs�)�u�o?��x���������6�d����!Vac��Qv1�6\�d�i$&H�������p�>�}��$��U�3=��I����CΞDL���U]]]��W{�����Q�V���[�^�n�X� ��$~�s�&��5�;�V�� KB���z��t=��a2���ˍ�H��LPz9�`t�����k;n�?�Jv��kF���A���������s���s�0Bi(��w��K�)�S�7q�bkRL�v��R�u����c)t�y�ʿ!��$��B�SDV��ǁ@D� %I���e�~
���)������
��WZxN����~��o#i�y]��7�ڵ7''`hu�(p0f�G�C��MW����L����
¶5,V�9��G�{?t�<�^.�����D��=�w�i��Ѝyoݵ�eUQ����t�.����`���]�Hs��"�_�w63�q[w������^��䃘���,� @^:�TQ<7�h [ځ��`��=\��%���2��C����쿾����P���_ۘ��>Y}��z�m����Csw�qX�>n�2�G��Fq"/b��BD�ǡ���C?SI�+�8�V�ͪr`n}�]��y�\�<�Po�>���3�o��|�����<���|~��_{\}�t������J���x�ʪ`}@�y $�N@.Uˬ0c���~/R��NS�$�]�%ʹ�zCu�Q.�0ߝ�����r��UË��q���;��l9R��`��yO�yqW�N�u�R�]|t�k���^����\����-���1T�Y��i�,)�Z��U!�TF��&��2V8�`0]�������51���ٳ�#6~� �%�^�,�k��`ʁU9�ݼ��$ND�2���1"0��i���B4u��mB�~�����
L|��]L������o�	=�Z;�;�e��;+69�����q��e���]4�I��2n�A�5]�$�Ա����g���C��a��qt��w_/v[R-w��.m
��~�R�Q�Y���:�����
�z��](.����B��R�\L [��h�Y�;������hwYyq�<[�(�c���h �3i�w�^�I�����	�yI�a�\�+�l�G���q}���|�w���<ܡ�ϑ_,���64�o+E�����A<W�\������+I�t���.�5�;d跒dhM4�V�i���,��A����U�J�DQ�v�"Nףm�
KDRS��O^׏v������ѱtzЧY��=O��!���Z����F�	�n�2m���j���r����99䑨�7?(��\Z�]n��z�8Eq3�#�:��L|�43�Z~�����L
^��4�����RP�k�6ܢ�%4QYcw���C�
����i$�j���UϿ�- 9أ�8Q�������M�x�rC/���BK���}�2-�[g�����U���)���Qy=Ǩ��D{2޿�<���D�C��)agso0��Y3B���~����<>h����Qg��C��m�X��n��m�Z5��3�x��î����8$Yˆ*��N���9ms���x�	�\�ǉ�q�K��{=���h�}�縱׃'55�q���R<kSrŝ��4�wίuo�.j&���;$�����"YF�����!�d�>�ZV���2�NpJ^�Ē�������D���чӯ�So^�9S��\�	�6#H����Q#A��a���*��QY�`��͘�\�zu����BQ�&Xd�,F ���w
�.cnH��Dc+b����|���z�D�@��&��P�,����nD���3��5��@2��؜u�s�0�#����b��4�Dz.Ӵ5<OOW�{��9*�Pm�����zs{{O\ �V��2��p!�=� &80x�s�Ð�u����������N������Kx�;oOy+N���XUG�0��`ڛ�ׇ{��zskow�Q7g7o�����3�a�t9C&=�J`��#��=hOt��z����vfR������H�a�d"��o�p�d%���LcY�[��W[�Wͽ��1�׌�M��J=���Q`���l"( �Ǝ�"��"�D�Cb%X�H�I��'�H8!��0&
���@T�Q���^,��#(}D���=3Yn�@�K�N'�]ДE����H���.�)p �p[�l�aEg�{�b���7X#���ZA��B��-e5�
�3!Ui���R��t��=Cϥ?x\򐦋br�v!��96�6�j4���F~ˁa�WF��iѿ#�����\a�b	��VR��M�����5
������f��A�=Ԙ��Д^F"�m� �D�����7��a,]��/�so�/��N�J� ������ f�U��i �ߚH���rFb%����Z��q��;�a2��G1��~�6��\i#�}����522�әn\Ejmu���'���<-D�r�(4��^G?U	�ڠ�af�6����>8�Yq9�ew����Af�*f��04�f�4��dfy���18��4���p%��4(�ؓ���Tv͈�9��#*����{�K��R��L�M|��I8Vz�B���v��8��	o�[��k,9sl&E8�����Za8-ٚ0ӱ-ٰ��ߛT؋�'�����~�nG-3��o��TѬ�>��Y�`�g��N�'���ra�gD3����,!��?�j�<�i�Rja���U�9l����A=W��,��L���I���I>:ޥ�C��k�:�
c�X��1��G�H�~��������r,���KX(Ie�D�[Nf$��XP�M���e�[9�$�(���V��{�T��,�vuE�W� �Z]8<"q�����Ʊ���� h�֯����S�`d�v�A`���]-9�8o��ؖ��'|�qdޟ2�~/�k
�e���*�B��	_ ?�	�3�W��cz[̗�=�Xc�u-��!m9���sС�0eq�ܑ��'X,
j].��à� �l���9��~�UG�a�z���,�8U++Z �.R��\���&O��O��ZN!>{$3�e�Dd��^�!T����1ꌻ͜�,�ZV�4=Ѣ��n�}�Rd�D�_���^���C}gBz`a�.ߐN#��s����U0tf��b�0A!�vZXV�;zK��kR%9t{,������]���Y[��CF�Ѳ�����Xk�H��}����O#�䎉�����*�e�u|-?�#\ ��:�JvX�7���e���KA*��YO�<�s�	�8x����;?�G�̈gd��{,,� &�h%Q��K�m]\�e��F��]��S��q�Ca=��!�e�pҍ1�q��%�)X�Ek����E�x���w|.���YD�ŏ� ��d��h+Y2V������"���?�D��V%`�y$T���n���s��?����_��N-�&���Ċ�k
�
6+�'�F������\�0]T����*4��U#Q��ʳ �@)}���h�FQH*Hիt�i}��z�����76A�J2��g����~��6w��K�����V�J��� �M�Q�ǔ�VaY��%���텗K��^B��5���(�+vt��?ZP�y�X�1���ӈ�LN���敽)����$pk9�F���4p1�nR3�#�E��0�!^r���?k<XX�rF������g�^�'Vw4�{�
+8F���
T�V��m;�<ƀ��K[�V+�\��C;��ו�h�G0�7�g�7�e9�sj�}Q#k�<�pQF=�q�ab�5���Gs��u���k -�#
N�j[�X#4�|�h!��*Ij����{.����vi��,[+��*�x�E#;=/�����{�?$bs��~_�(M��:����F�z�o��	��k㛪��~�Mw������d�r7=����B)��c3o�j{�����Q"�No�!�����W���5�R�VҦEC������j���P0vw���_�Y¹FŧQY�>w� I9]n뙒��%X��Z2��Ӛ� �W˶^�����--���e��X�b���(5��8A��-/n�B��5nZ��Й��ǧ�<@���(K��$.z���E�Mk��/�[{=����( �!Z�&ߠDV�f�ܓà5�k��=�Gf���%���ע��K"v�ե�jN��6F'Wn�w��o����'M�Ե:įH4V�'��s�ed��
Vɞyŧ��sC>��!%-�W9K����w'.��O[���q�ޢ���e��2Y�Ҧd���y��ga
�*g����7�D�����1ƭW������:�X�(�c���j�a�ie�Q�ȪJ�T%s1гE��H��2s�R�2��>��{��>��g3�I����� �	î<$��ka�lC�Fш׷��Hoi���?�|����M��"�w�{�w�#ud���`�Vl����./N�a�#�#m)�Y�����<fQR�W����Ǽ��V?xM^�Eb�>�B�R�i�/�gt�	|�v�A�*��傃�
T���eQN��D�����uu��HD��?�Ғ7��e�x
�e�s($A&�
�9�_�k���Ytvʉ�*s�բڕ��އ�M^Vi�yX�&م�e���.�fͮ��i���P���YP?�P3-���>����?�u����,���[�\�3�feԺz�u�������z?h�f{��E+/�̩��1��B�5R� �]�`h����}����O����>~�1�������`���_��\����׺`=%�� G@td�]��>D�5�r�ʹ��R1)�fR�ɂC3��<⨦hx�?M��t�t{��q�h������=>U��2q��*�8??�Z�;u,9mf�M}.&�(聄Y�`�U6+�I{G��<D69~�*U��y�f�͌7��5�=��DZ�`eJKR�p��M��Ֆ��-�� A>�z4µ��\�ܩ��+~5�[�T��b��F����痞��Br��2��U&�-<g�Ư�"!&��N=�&G+��᱖P�&M���<[�e��;���'Y��I��J%U*,�_���ma�q�~�W�U���"��~��六m�:~�t��t�`9�s��z��$X�E�V(.ޜzoV��W���Ŷ�E?���_ˉ9,�z����ѼZM�~?]Z��W�~�<_P���t�E�n�L*c�j�r�|����d<�Y�WdX$��gϡ:"��{��#���5K�,��W���S����ȃƬpn���5/�h�*�V:vEqHL���@�i����l������"*	B��а��`6S'�!eE� ���M����bN6j�Ǝ���ťҾ���\�{�����LHx�P��Og��*�h$��J��p���}Zr}#�Ϟ�B7R%V��V���%Dj?gb�

��z���[�Yh����[��d�~���f�Ϙ�\F��B��H��VD����ŁNg��s�?���{W�i��;�I���? 	I��;�r^��֠U+i9����)�0O2j�����F2����7����*k�j���nox�{FoGTb��)��a����l,��_��U�D >�q6��om���KɊ�1:�����$�6�$��Fi���i*�T�hU��\�	�V��/��iR�e�;Ok�v䠰v|��(�f=��4[��nR���n;�?O�9_p���Z�DMef�)����P� i;�7�-k�c�B�I��:���ӏZ�1^8bE%�~�˦E��A�h�þyc+�]�_�~��33H����_*�����$��~�j�F���{Y&y��$��ÏS���	�V��/�ny(�K$,'��Iv�u�����xQ�t?�VՃ���YSԺm{�#�K��)X��*��і�&'�6��$�������0* b�4+#}�YO[��2r�'/WK�ȗmϾ_k���Z(�Yu��l��T[��VI�`A��6��J%�.V�U��,�ƥk�g�P+n��J�r�P�NG�(WΏ7ޜޞ-�O���4�ظv]�l�:V��u�'ɘ��S�dk6Dq�FT�,sh�,s�W�S�X5f�����y���݄.ɑ�e��0�<��i��1�ƴO�.,��l�������_��g���P�ӿx/I�α�,�N�npj\'Ӓ����@�O�y�����O���]-����^["��`m�-���TYv[��8��ۥ�2U9WTo�>zJTl�r�j�����w�t��wXO^�]?D��C��3�˹�F��H������S�`}K��OLnK,�_#$kRجI���u�4D]�$�E.�;�Ӟ�O����h��l�Q�;
s���o/������V{�l��A�O������Yq'?�▟K~��eWg�5%�@�!	ٸ���#j���'b/m�^(������i�e�v�$7�v�FtdK�.|�7Gt��?2�pk����_��!w.gx+��b i֔ '�q:�8`eh���؊Z`�����]8��ZW�����t�^C�u��m"��I?�0rJǃWT6i��P���w�+|� ��+: �����e���L��8�t��{GZ i@���r65�D�bo2��i�����tw����t����>wg�Q��r6c�[C3(ax�����t��@����;R�9IQ4aI�'������C����>E��ܿ���?	�^��;�gzc��׺�q}�?�O���������Vd=�.T;ʑ�7t^�͍�P�|�c��4�{��+�
�Z���t�_���=�h�$��-]����Wf%�0� 	h-FN0'�B����	H�H���Pπ�`�0��u|�φ��i���S��k�W��|�'�L"�iSkZ��lfgb=�&�e����Z���w�B�j���/4;����F��b�^Gn���^z-�$x����3?� �-�O~&� ����Ý [�P�_�@9m	�ǹ���J��(����Z�E��g?T
7�8/��1;]������;;��*���Jn/��+�T�q�B�U}kG�*�Eg[��'�0�ݿ�[�r��8�<ɮ[���~_*�V �IφJ+��S�%�d����.�p�5�ùC��(��~��Ф�6�����e����e�D�]2�P��z��mS���@���A�t�V/��ɞ0���/T���Q��7������-3IPB����KS��<�� f�P������g�4� h�w�<!�^q�3J?X� Q�h�j5���#��
�T*�·��MHK�u#�t���=z�3Χ8ٛ���3w2�خ������l��.��~J�ģh�Z~e��8?�NgLfw�M�aF�ꟙn��2GS�w:�i|O��LxY^��t��־���d��̕�� 7�p�īdN�dV������{�ɫ��O�'���X�PI:�3˳ß8@��7\g����5�	�-�� ��܀ť&2����s���_����?>������֪k��_z���M~�m�sHz�/q�_���}���������%�.�
K��c]���� ��ۂ'����zcBk�+�DtoG9��-ܔ>����xQ?�9����N��j���ޒ�O�P%,�b�$�a�T��
�T���cn�y���y龸��������ӵ���u�����q��u������iR1]cdo�ޡ�W}S�
˿��jK�xA���	��u�,��ƹG�W��Ի,P�S��4��I���_#�}������T�������k��jW��Q��$��fW�*��4�`��Ii���m�b�����K��dzשA�7~2�)�ő]H�ƴY�ƞ_3������0 0l���L�}-����,yJ`�L���9���J@�\]X��!+C-j,ʹ�n$�?���v�(h�\�C*���>���m�m������k�����7' �Mn�܍����9[�\��5��`�h�|�aY��R0��CUU*��������Q�Ͷ�#��}x�:���0*���n֖�6����M����i�a� G�QS8�@ao�����\����� <[�[,&F���07�T��y�:��X�� <
6a�<�@:���gc�am"�Z&�&2�g2�6&3<���x2��D���O&2�Mfx:��:���V'3�G&�Q2�C�������Ҋ���A?1/�Gͭ����[ǵb������w���9���ϣ�θ`��L�,��2%7���ƺ�4́�k[\,�m�_֊�����MT�M�ޝ�vw���ɏ�N�8����϶�/�E�"�k^�h�2�_��`��ڮ���u[gV^��L���[�cD*�H���!�h��C���\BO�� 3!֟�믭�q���V܏����:�~O�S��߫��b���줥�I����n?��
%|R�C\xD�K��r��.u�z;kg��]��^��h�mg���J��9)Lk�R��F1'�j�_��{x�{3>��'P��(g�{3�Đ
7�%�4�j+c�u�����U�lES���%�y[.Q�o_������n���o_o���oݢǷ?��=������;����Q��z�����O&�o�J� ��O�l�bg-�7��������b�Yl���k�����Cxm}q��㵍)�ߓ�������.���g�gFN0�&#���{�6H�li4����uŶ@�达,��AxY�Ntwn�t��,����9ڬ���Q׋�!m���4��:*��ޘ���*�G:�R�+�"{��X'�ؗ��kO'�?�������.D�CWb�}��VR#AXO�@'�	�1@���
�����e�����'�$�+����
r��r���X�P}1�y��]
\G��xS0�����L[8ħX���"SR��[��(�;��*ȏo�%���Z�A5�0(��Q-o�u�U�-�>nR^t���5���3��N�Ѱ��v���f'b���'v����N�m%o��2'V꺝�{}d����_m��XP�m��T��R��l�y#_.�� 1U��(���u��F����j����o@�x&���������\����LT�y^=��+����?�6��8��>8گۉ�$qo:��&M%��V;�x)�Z���=����K���w1.�z��w���L3������7��������l��[U)/����\�HnhzO^�7��7{�����.^����BA^�6ԔtuJ��*��q�p���oh�;=�4>���4]+.x9�0f��4�a�D1Cc�GR�!�^��}�{�E�)N&��m0(Z�X�!D��[��~���9x�����	��s���"�:��Xs�7񂹀�Θ����U`if.��� ��������I��Z���d�'��ט9��
�����
��(h^X�{�`ﻒ���JYl`�,F��A9I�k!��b?���ؓ¨�<ٺi���*�4��r�>�*�bwo��O_4�]���w����U*��?.~��=6d6�i�47w���9܋��T*��t�5��Sf�,�q ������I�u*/�y�'Mn�+g�"�x��R!�,Jgs�̙5Q�V��n��ns�y��"H�&'��*�rGf���O�3wLOs�옹ˋ���gzo�Lgh%Jk�-C_�wfիVV����'I�h�^4ezD�����W����}���Z���x��`����?ڿ����t"g8���%C3\r|8� :RE� ֒ɮE)�	M���F���b��P�uṲ����P�Rˍg�.�m�
���ݝ�W9��%�:�ȗʑ+����1L�VAg,��[W%��xL�r����Wc��'6��nw���n{e�A��M���D�ŏ�(a�B㸫��tX	�C��'�� �HJA�u<�a�%ฦO��������=m�#]4><x�k�s� ⤮;�"�"6��� ��2���c���J�-�O�:�Q;��o���X<y���#1=�)�X�Q�=��(n�c���e�H+�1��R��t�����C��09���hlA����͌�/d�k}����B�e']��[U�k?uEy�tc�\���}��(19�%�Z=�{�؛J�T�aݕ�ӂ��=���Ș(r����U/��lf>j��j5wϊ妖n
܋LW~�@��SFaep�]��ԔRbs�"�^�T�TP�$Y�r~\Z�W��|�[鶎d�=��1#�\p���`Nͼ�3&�j�g�)�ʓO��)��j�A$������s���������է��/#�-�w~��>D���זXi��^�ѓ+���x��:9~�l ,��m�pw'�:󷴈���9��n+����	L��C�j0<���G9�,d�+?l�/��G� �z�����ڔ�e��_��G��L�K@�1@,߻8��sA��ua_GCYL�75.v��tV�^�3:�Ε��_m���MW #|��cr�?^�>y��_m���nW��7n�@�:��.��	�
�np�Y���4G��v�I���d��]W��KC�UD(p^��B�!�������xq���������������?��׻�������_k�������(Sg����=l^��KW�d��kL6!d�B0�Q�SQ���a��p���3Vڦ�🇛���������kՍ'S�?�����wA�Zsp�oY��f�JT�Q�s �w ݍc@:�կ�yTI���$��a[U��
U< �#q�Į?PyY�yul�G�h�{	�k�a,��|WG&��g�pX=^XE���pn�,�x�x�i�}l�5^&�8U��.K�<;ˉ�2��;1?*�>����O�&fc�a��SQ�d�I�8�h��F���J���JYS�t)i��F�'�Y�ʕ��㷩۰����+���]\�E�}`�q�,�1��M��?�),�_g4%4y[��o{A�tK=�m+ ,�n���b�sc�Y���e�4�
�r7U��n�DB��ZLɭ%���z�3o~�䡇���kő�FP$�)K�x.������ۊ�V��iwr����83G�'��H�ᗦ�`eA�7�+y��u&�����p�4��-�/�ɇ1|���^��:�yy_yDC,n�W^1�,�����9st��?���Y�?��>������Xڼ�J�>]��u��� ��34�A��#�V����A���p/�]s��n��)Af\P[���CDjZJsb��~�r���J��zMb��� �\C�]߿t�j�|� 죮s�����QB7WVL���Q7Z��{t��l��/��z�֖P�ϗ�{���/�������@/���g<���~m5}2�SgILU��R1�*�b��NP�ʪ�DN?�e]��w�IܠZ�q<�zQ΄aˎ*���fY��sq���{���/�s��G����Aqf�nh}�"��DbB�{����\��p�.	��b����D�)����K
����sۉ�!�$^e��Rw�h��d��g��Qs�f�r�kOU,g�Z�|�'f�lϏ���@�����Q�t�W�B5O}�5%�Ά�2�1��Σ�����~
8�t�8@|��ur��bD���=��xU�S�һ�	xuq�4Q���OK�5*"��E�����'|��ԟ,rd`�R��Z�jd�w��復,0��D�hJ�?++�u�,ݑ���A7��%S�{8����9�H����׉�֥���������������9�?����
m���oyy�cNj��q��U�Ƹ�����:���tu������K5+�[�����}X��D�
�[ z6�,X�SM��O��9ڌq�펎�3�k�s?Ct[�I���FW����~49v���M��l�n<������,������:l` mt@+��V��J}���fֈT���Ě���{��̆�@����^/�����9D
*ْW�2g݆+Ҽ�@�ǙI�z�A���i�K|�/���|S=[��ggT�R��+o�6�8Nx%7!�%N��Gȴ�����7�d��AУ4����u=�AA��Z�`��U]�,�`�m%1�կ�?�X��F��4�	��ұ��}���<=w��1�_�����Z���[4��A!��W~)���S�?^L~�V~9=-��e��9[:=-����������i�ve���b�Z�]N&t'?l�u��T�T������s5�����]f����3XS���t+7�i��U���&nU�!YUR�]`%�0j��^��TM]L�l�������9�|2�D�{�����ɾ�ʍL��T݂�����_��b����������1������`��E�����Q����%�fX��6�|�������C'��-GU�/��7V'��m<y���q�!R�0gJs����V�n2��V�uU�HL��M�F��pZ-�(�A,��nE2��j�@NI$��V\;xq�-��F�_9��9������q�q�_?6�����o�à����'3�������_?f��k�ZëvN�J��*^-r����1N)�l�m`r�����V,��1��:G�$x��xc�Rl,�#�<oSR�֍������4RFӴ<�ܼZ�g������FR_�� 1P*+յ����l�?����M��]���Z���lNf ޙ~zk6'"�Jr4�%��E����m�Tm��S���Ο�7h�|.?�+'�/�o�R��X�{����Fc�e�a�*�J��@i�mMC���d�Ԛ$=}m٩�e�i~�+s\s��8�|O�>�js ��BZq��V�M��v��V�d��XF>��_����[;��s�}J��������>��~)��_��|`��$(��� B��	�0����v8�64���:��7�1��8�G�k�X��ר�o~�
p'����Y�,�뇆6��{	���U+"���_3��)À)��C��7 ��N�:(�ɟ��h���r����^�~Zы�O���<s|CU�U��$�����ڶ�]��?{O��H��~���K4�r��'e��L/�2��v���T	f$��hi����;"��P��.gw�WGǋ/�����)(".'l�[���{J;k7�����@�^�� }A6\e��}c-n!'*�w���&�1����9���.^%��\�^pUTǁB0)�[�g[�A��&�4N���b[8�����xE>`&��Ϧws+f�j�y{D���eld�\1*R�?#��Ul�ߝ�rᅧ�c�X��[�[���~*�@�_n	�n@��L������o���q��YΈ��L�.�����2~��P���m@�!���h���#ΪI���kC�v�}��}�NS�����V���M1���� <�w���Λ��������V��5��S!�3-A>��7>��O_�`324������
y��m���E�@���|8|���#T1@8GpyP��S�>��1Ϋ��Q����1@��зV[)�����j��c�WZ��������J�������s��5V�5��P�^�~H����G�,�B�<w�dO2"{�2��ا�m(T���"wz�Q^���>ݔi�'ύZ�Z�М���e�g�l���;8@�n�*�}�7�Ѐ��]��C�N��|�+S&���cv�1Xȸ���N��{�9��;�w�J�|6)��l�!��Eٝ.�g(�scl���ֵ}�KF��w|:�9fD0#� ��o�F�-�L����:G�,LV[��	�G��m H-&H]���qZ(��D�#m��Rm�8!��{��v�f+J5�ҙh܀h;�
�;�<r�)��`F��	�is�n]{p	+�F�R�-�����pU�0�L��j��e<��f�}=��^��*0���2�<U�ZV/�"�X��,Y8��׷͡}7NQu�"%������)��t0��i��E�c���S�!f�u���}���N=pW��EG�puC6�A
��v@�J>.���Y� a#�G�{��ђE�rM{��wCT�R)������ۋ��6A|~�w#z�ۅ��ê��j���Գt�ny]���rm�M��F�*Tq�Bܙj����5��7u"o���)��R2�^��3zs��y�l�ĒJ�����FD��'�bp�.&���h�x�>�p	S�;�֞�br݋N�L�@��7#A�;ќ��BY7�魨k�����ާ�������s�f��[�#'���뷵�p���Y�����.?��C�~����z��7�6ŖX\d�>d�Dg���h}�ޝ��83��C㋱!1��ff��2,qǎy,�5���_`∴�|�������ПW�>nmh-H{��l���Ÿ�x�KU|i�m�^.#�{l�On�awb���غ�n2�ء2�����T��u��ӣW#�^PA	>��퇃�étQ����?���8&�7$�~�(�yI�'۴ �3�ĵo�5���3�CA�a�eL+t) =DWo��6�#�č����5�¨ ���Q�7a.�cP��XU_���x�@��v�j�rtT)K��>#v�8�R%�Q�8��ѣ�b��y���:�+���0�
=MSCA��O��f*a�o=�zp5�B� I�ڜ�mXf��B-���C�J�3��>����6�76܅�6���������7�qo���j���(:������P�+J�M��o�84Z����ۄ��FZ�M���m��TH$�]���5��T�����E�r�A�h�$�[�x�ҧco�Ҙ*
���ݩ���B�S4��ۤ�l�^�Ak7)`a��[�c���@�� ����Bn�r��^���C��vGrGA�� �r�r�ܮ<���������[C�n�̀�E@�o<]�bnb�N��e<O���u�XF��ڄ	���ՉŰ68��k���bw�)�Y�8\�ڍ@��S�J	٥�mَ�d���xx,Co8� �qd�~��}@Ł]?�o�1h_	n��K�)�싺Q�f�yD����@�dV=M��͕ᷙ�Q� ֍��[��1����@�k�\�BB��ϠDg8�d�K�x\H�~�6����D��ϋ�0�=�}���c��6�[�\Nf�(��Ҫ�i�
��92úl<�)Tm61)k) ��ê�B��8J��C�IU3d�
� ��U�o�����'?��M8���W���	\ԫ$oJ�?�$R:G�ܤ�����R[��vP�
������aI(B��V.�����^�/-i�T�"+�s�[gdYW{4�&aѬ��=(��սΡ�~�Q,�@�v����}9z�cN0���y���	rު��ZP�'�N�h�!+J#�`z���K���e"����&�|�-��$4���w�''x��� Er
���+�nzв�
�.��x�X9��DɅ����K�^��z!��$�Z�鿊]�qz�����De�돀�Pd����y�R=C�:�E�3��3�w鴌kI���%h��c�:ݴ��{b�����7U��=�V��^=��׭��p: p���������&���{E���f����4pPWE�$�Lv���7nc��%0�ucv;��XL�����j�E�i�Ck&40;�/(����S惕=��	���'�����rBY@~�I҅�����c�����������?9�������?Xw��1��{��͛��9��7+���[����B�Y!��^�5$r����]C)�
�Ȫg�M�{A��/?��d�]��%g��5`�pR�{��c Z�s�b%��8˂���V<�/�#<'�X�Z�6���=;l(0ӝ>E�8F����Ù���1����B}�[:ť��/[�Gk�@��aP�c����n1�@�����,}J��.��Q��903� ���D��G�(��G��T��{����x|P��j��"nM���:noB�w���<8N��QX�=�/�5�����T��̜���s�Eε$���m��s�Ѳϙ�s "{F6>���=^>P�Y��)����e�@�f3_J�et��~��"Xe��x�<ou�����e�^ \qF�c�;���;��G#���h�Gǀ�XUG59�9���s����ԏ9���b���`�\wz���)1����Ni!Q�^bA>
F�E�)�G���'� M(��x+ 6��&��yJ��9&e|�2������{�"�+ұFmE�?}�jK҃�L�����,(ڱ�q�ܜ���~"�%P����a��J=xi��Gnb,����>�=�t�[���ǰ����]_w�kw+��مL�2���W(���aѬ��I>��f�:�r_��]�E��%9Y�S.�q�`x�7ݜ�E��ߠ�>��ϑ$�U�QC䟆��cz�6'��&_co�30B�x;���X! �K]S>�ۡ�.?{ƻ�!�^�E�8��!���P����&.*��o�9	md�z�+-I���nsI��@�>?��1U�,��6���Gg�/�D���x�Λ��E"Z�M)x�'�����RV�����cƖ��F�$T뻐]4�Ki����;�����}���`z�����==I[0�RT(�Oߤ_�����z�����3{7��G�eVS���&P)P�H�J���Z+����z�&�ߴ�q�{�$�|FxuᯕZP�k�������j���{�s��V�����G�#��n;���P}K�?�k��;�+^�79���hZ�^�r]�m�g�����Z��
�t0�M0�2�+=��T\i�/_���u�6ď�Џh��ˮ��|~�������]������7�_��W��v{ ,�%��Q�o[��c��]|���~������*?���m7��W����g��p
����|~v���_�g��k��?���6m�[ig���6ׇd�U&#Ȱ�A�(hb֛?{W����#��Yh�f�6�]e���^n7��os��;��K�M���땸 %��ٽF�e (�.����q �ŋڲi�Hy��9us(+��&�!���&W��+�B~o{;#6��1�E@��{������؎nHD94��&N�~��l&1'�H�-C#Ä�W�|v� ���1��ޣ�NwHfEl7q<��h��q���|!N�5���/|)6x������i8�5Y�h�{�,���"��gz����;K7�e�)~�~؄��E�����I�e������H�%g�Ε>��e_B\E4���`��u�N�Νz�fP2(i�L�=�2(�م@�*/:�E�jP��S��i�5�� {0��o�g"�J�
iє��\�%���?0��Ke�@��ſE�L񽥾`;�=R�@�U�x@Һ����QG�Z)}nFr#c�J/�žk�F��7�u3�=�Ka}���k�j-�x���i_t��x�{.�y�_�������׽�����-������������������.54����}���wj���Mח��a9Mc�hMZ���p�#��M�+�C��!R�nx>J��ˑ�!�d��J�r�MuKl�3l����'�V�u��\A�h2n�w��4/���I~C$Q�_O�#O�8\q1��&M@��s�W��O�/:2F��A��!X��Bz�x���M]�<H&���w�9�3��-BwŢ����pZ�������z��wvvW��Wz���Ln�Z ���2���!������;0t�g{�A�&���ǧ�5QY�(�Mn����C,�����?V7}L��0�{9�h�m�[�/݆t���A�`������c�:76��˘�Q?$�����,_ژeg�M]"D>.F�J���d�u"��FKwb1;[Pͱ"���A��Mؗ��b4��1���T2��������L���߲	c@SP��rms����l�g���gg*~d��<6�3�P�$���˿7;�І̔NKXs�� ��C���#P�An0z��f�2N߿�i���]�hh��He>TDC=�q�W5W�^=l�/���ꏕ�Q�.!����eONq\=)��(��!��Q���hT!!Q�C�e�.���yͨ�E��VE��' �kųFŨo��Y��\9;� �|�TN+(֨nP���D�P���1�Z|W9�4.�E��Vi�a{�՚(��b�Q)]�k���v^��V��K'�ʩQ�A�Ц0~4��~\<9Y�S�?��w Z|wbp[��r�f�إ��O6D��(U���ɀk� a֍���B����:�a`lJ5��j�/����E�G�j	.�F��Jɨ�'�:��nlP�"5@�`P ��]�+D��܌jdB����� �E�\�q��Qw�N��%�E:� l�����`�1��H�:ЭԈ����H?řq�2�d`nἯԍ�Y��*���"�z�@ǧ�4Z�F������b��
�.�,�W�!�%�s_�X
�!�~�,zj�:;o���f�ӹ��RɎ��]Ԇ�`�ǢM��"���=���J�Ț=.bl�(O���Фv^/���0���#?�(+�z��Δ��'�vZ��ٽXQ�	����p�Vlk!^����q�䧭�����8��܆?z$���Y�K��
��0l�f0f�`E�c��d�z�Q��9��gP �c'{'v����4d���=Z���p:|j�z+v�D����x���1T@���F��NB��֎�m�B:�����Fm�#�;@�0�9hBZ;��{�ƛY��#�1A	.�B&p��C7p;�:}v��C�Vo�́�6�5��)�3o%��S� ��,` y����$3>�d�ZpBv9��I���8�A��ob+����N��TJ�(�{x���u.�QH�箥8,�y4�( ���B\c�.����h��q�]�N����F��4��f�|�B��[�d����_����n09ƸU͝��2]�|��P1.���3�4D���aӟ�s9 ��b���]�������Vi&��C,�ů�@2^��݂g�vZ3�0f0o&mfk��cX��H�Z���j�ʡ\@2����b� �)�|�>M��u_�v��JWXs�\�jfu�]�9���<F��xf����y�R�`��'�V�H'��D�
 �q�[����7��m��o�t�VHDC2s��D`FN�aX�����X�3#�ތ��� pϒ��?��/�����������o%�[��V��o%�[��V���_T���=%�{]�d(�1&>���)+ф:4��:F�Ҹ��8O��z���JiE���?AQCc2�,ך�#��/�����μ��֊�[�+�o���������V�ߊ������9���a�[۶�����W`i��SW_�ʪ[7�nsN.}��ݳkkeJ�%�����Q�� $H�(_Ҵ�b��` <3Ҿ�l6��,�	#{�i�
���c9� L���ԁ+��J(y��ւ��O�%���?���#]����4�һ�/m�+��#��8r���(f�H̦S_,/���Nɖwa=����x[��F��JNh�?ś��|�u��a���G�߷\�
�P�xq�ѕ���8T����P
TJ�~�HI��H�F%�O�3
����I?�ŵa���^��V�Naǒ��װ
D%��/��+vo�J9<7��	k��Ƴ�����e�=���b����U������˩���vP�P�zIĊ+r��OE�����������oX5jSEԲ�Ë74�b���ܒ�;���7�U�W�@,��Ե��yBYĵ��q�[=.��i�~XU
R=�=֔����R�,� "�E*+A�b����⭒u���C���B�/$�_[����
c�R{��VM��.���N��|����hOWS<��Ѩ"����Q;.w�!���fg��S6#��΃�[�f���M �����<%���O�� )�5�GԢ��b��N�����j���<�p H<��+�7ʎJu ��g9�e�r��J�z�p��.Yq^����Ct���ϥ��m��K�e͙�^[7�J%G��ݱ�o�vgU'�>^�,�m)~�T_�����~|��Ǟ��	3��t��O�B:���y�L�X�����^�f�,e�3#k��Q���o���$�&�(6E���;ŅOa���r�^���؎��T�X���0޷A�o�ۗ"i��1@�bUUs��"CO8�e��Z�? �U;�8��,T`)�ݺ]#m ��4�v��v�j'ߋ���C�RߩA�J�($�A��>��	�)�0/��k�!�J�����4;�j��hc$O���������g�ȉ�*��e��Ub/���`�=������c`D�(�`L�E12��".p��#�Ra�o�˾厕��(����Rk9����J�,�jIle��j�&Ղtå�nǴD� ��*�59y�7�`����2��B}Ebu��1�姺���������1�y��v�S�h?��3�$��t!EQT������)b�z�v5������bGm �#}�8c�2�AF$���n��Ӥ��{���=W�H(}��f��0���h#U��
���j)�R5��v�춁=g��ݯe;���
�ej�,j���8+~{�d'��,X4A%��.���gIt�{�6����e^��Z�����1���߉�-�8�	_��b�SUAJr\���ޞ+��Ƚ��ߟ�f3���X2_�(K��rbN�%�++)ŕ��@^�@�����P�����D�܁���F��`����՞C5g��x���x�S�����{'�+���8��M�Y^)�An";�X�n�`�
��I��F��@���%ׅ+���Ӊ�
��OY�ب��*�:���)U���9W�w�Q̼���ì��! �T��S($v�m4S��7,�(_}u72��'M0��RTJ�/��}���Htu�������r׸DBT�CK�~A�:��ȿT�����)�����`���eg	\^��SN]���@�=��B4(Ar<�̹V��ժY��
���i:E�u�����%^#��Yi�,�f�j��T9��R8�B�++��.B~y� ���bo�� ��{{����X6��
��@P)�*k8�x�&/�_�(����C�Sj�1����r�J`�Аg��v9B?$�������m��}�_ :!҅�xպ�����r�������Z:��g����G�O����>�������������u�ʞ�<�����q����1��M�@��%�n���E2�K���4�8������-���ɶ���}�9��5[򌃳$ �Yx�JA���I	2���:2��:4�N)B5֦����*��ত(�wY�������H��n�;l�}w���N�@�%����ܱۓ�7�n8d��ϗmݝ�Q�ὗr�g;Ŋt;����i�}nTtX$v��5º�Ja�ʷ;����p�i�:���՞��ڏ�k[�]��+`���.,�����s��Y�uP�j�z����`��?hf����C}��>��������>�������ǝ�<�[QC��;���U����u�0O-x���e[^�y�֖��c��[U�z�����K��Į�����bY�:Cf�*)�w�#c�Փ� ��L3��폈��t��w7����F^k�����w2n��5�����P����OH@��@Ah�0��*2����O�(���'4�X��Na���l�p�	��I���p�*�����n6ǁ�ೱu���a#+���w��\�����Ba),��l��J���؉�=�g}O��*ڸ�����������Q�����ᡞ���O����O����O����O���l�{%��K�����hg-�	�ו�?k8�NV@��ކ�D�cYm\R��p)�{��a��P)�	�	���t�|YYο�af��?UE��P��s��Ӑ>�aqۅ>��㈸����9��[�k7x�I��tdk��:eE���QP�$L�s{ҷ�wXˇ���h�N��w���n�\��H�+���ˌ��r��<mv���
+"u�Z\��SdRW\<a��6��i�+Xh<��������ku1��w�k�7����_��@��������w�d.�70��ԝ�F)B�N^n����x� ~u��qW��[�`�mhB��=��\��!�����
���\�Q�X�|��ФӤ|ƣ[�T��PRK̘b�0��BS��h��x|�E:��JF�	1�C��o��p�̐ �D�hn#��m�J����8C���C����%�̔�U�eI�1S�Z��w�\�;���|-�L�5��>���f
�^�0��Teo�+gD�hu�l���%��-BCI�i���<�y@A�pF3�Ʀt���B͚Y̳��R
y #t%��n������'7
����F�3%QΠ��)�̐�~�wwQ�_�".g�O��rTy� �L�=iwAXP�'ϲ��Ԙc�.��%�.G����r��X~�=�#}��ߠaǽ8v���G��ᕇAg��y��[�/��dD3 �K��ν�op�?�"����o�i����p�'Z�"�Qߝ��1�x�[ɺ|*��Q�V�,�c铠gzia�e�d�ZY)|��ON����-���G���9��]��z;{�[�`_�^��R���׻ Ȅ{* abH<�||b=�q�	�&]D��f��0�%�k_ٮ��h��Col���f���$ZP�H,O�ǒ�*B�&�֍|����c���!�8�m
��:to���Ji�5��n����Jy36yF x��k�|76��vY�y։5BC�ȫ}0��#����6 ���F�Q?̬���L����C�h�����?����������WJ��;�:3ߜK�O�/֟rgl�����r�xNUʝw��U���Yx��������uG�b%�.�62�6�6j�x��绅J�u�YV-Q�XB|��q�3q69��E��/�B['Ї	3����dD��.n`O�Iw��G��?O����?eE����ק���V��ءGD#[A|��)�jt%l8��0�b��(���dgA����v���'����I�}Z�_���h�����y�T�Ur���իt�j�$����Jdj���MY�cM���2�f?\�JF鬤�j��\:S��Pdv�-W�� �%-�=L���arm�iI�	���E�����S䢃�SŸDq.���e��<�2�T9�@x�+ۿ4"(�qb/Nl~;��>I\ָG���[�,1��s�|�$��������x}z�����۝��h�e%=�v�kh��$�䌕ӲGnf��%aOX#�.^-�����K��V�7$6P#�����y��FE�-;�r߽P�`)�����{ԓ��� ����ݪc��ۓ�<徝D�2����dA���,!��H���qmŲ��=Q���?/��ay�Z�N����8��L��4�[�sb��KC.-��T`�f��ءmo1E�����p��v����ވ�>�Є��(�s쿰.F�Њ�-<���o5�������0��xS�9�9��f�t+`S���A��g��h�k����k����k����k����k��������=r�~^)
��)��x�Bf����o1���`;�m1v�M&��f��,�)sT
�h~>�?�c&f�i����6���~6���A�@���5���_���5���_�������( �鐱�|����@
��Hk����������c6���������_���5���_���5�������X�n�*�(�6��+�@�����@c���b._���C�gB�<��d�wK���b��L�xX����F���z������4���_���5���_������0���-�S��!����t:1�ߌ����������k������k������q���V`lP�c�����=��?lƉ�V���}\4(��F���EL������Z���t�o��5���_���5���_����w� ��������<DZ�ne����:����>����5���F������<��?|����?q	x�۟��N����\v�����ч�݉��.��ͪ�ך���߷�&xf�S�%ꛇ��󿈔���?���5����������������������������\K#���\J#.���4<���L�k��Y,P�4�?�� �3��������5*��(�9��pI�elo���7t��Ϯ��f�ۨ����Gu��}^�?����,Hb�ݏla���V�����7��8������1�>�Ю~.�Al`��h��K�\��o�2\}+�̻��kό�K��w��F�#is�.����y�CL�mT��c��)��:V�	��o��9.HJ�M< �)�s�(c*��^�D�\MH@y�|Y٩�Uf��{��=L�(�B{jVč����;��0���CS)�?IW���!��|��}P�G�P~F�G`X(=�1�兢��!�fs�@ɵ���tl{�?�<����x,�*�/���/�з��8�c����9��NK�Z�l�2.e��d5[��u��\����hP��P����[�����
��GI-���D��/�+�<�=]�xx�9�~b+�{��`J[n��9<���p�u�rv;�̽�%ʑ7�`n�q���3�ㅑm��3И&���03//���:!uIj��KG��2dj(=��NŖ��.w?��7[���?����D�`�w��a��ef�V���lf���Z���������������?z�G�����{
���=��F0����+>�~������`�q��Զ�>�ƚ�|��rI�STȌ�5��B���P�M��j�T���P�jM����5���8��>����<�Q�<�?b�7/�Y���8�'�o��~^�C��:q�����9����a�({�e�����i,��_���Q#���:��������?��i�O�Z��������N#�R�J�∏0:P��?�����I،���G��k������k���������a��gw�5�����iF�;�ͱ?�7( ���d��a���h������k���������_P ��U�Et���w~�����Sk`�l���������f]����_���5���_���5��7�ω������Q��C[ت�Z�������봀M���=�}x�:��_���5���_���5���������x�X����}�8�{��?Y����?��������O��H���5���_���5���_��G��?��eL�m�����y�e>������l���$��_���5���_���5����>���`��������*���a��c���ǝ��s����������_���5���_���5����n�/�d�=�t�c�ϗ��h��^^�h���3�����_}� ���B��#}�����k������k������?��}�x0gr�wq�u��f�۵��^�=_�0���\�:�=�����y�C����ebM~9���Iڟ9.L��_�<:��/��br%��b���.��ń��
,X|6w*y����ZV���B���D������f?�1AY��0��\!�wms|3۞�OE�lh�П���շ��/3X�����l�%j��/�����5��Z�������6������G0��cl�hKQ	a�g�A��r]�?�� 1V=���Auɞ��7��䀹�r�p[`,��?���T��J�F�̱Ka;9�7+
�'3�f�+��<�)ĉ�>4��U����� ��p`}@r�ᗙ��!RB��dԛ�a���?%�a�N� f��=0� �ϠC��Ԣ�)L�3-��wo��ś�޳��_�j�@�1,�9� ԓ�r����W� \<�}�Ϟ�m��S)��\u$c��%���=�_`J𦲊�RqIBL�W�x��~o���� c�g�8|gC_�PW���o�-�ںMh2	)po���ۿa�^��j��Y���\�Y�,�e�iP�HP@�n��?e��b8�z���t�����c�d������bE$�IX���ӌ�^�"f�r9��S���ş&��4��Fwn»�튷;;��m����vw��JE�#��d :PC�Ĺ`���y��G/YvT%�ƌ� ���������b́�hxv���{�ڎKGE�X~��*L��K���׼��Ԇ�U͛�nEdX�[!3t�x�n�[<J��uJ#��OSDR!���+Κ��G��aO��co�b��R�*��ngn����w�1�t��e �懻P�rg|�)S�V�+�s9qU6�\b�Lv��m���f���rS�R�3�9��"�.{��T*i���܄c{p�� $5����c�a��^�*�Lm���@�^5'���&8�� ���]�ϋ�c+���<�m!��ڄ�KIk�+�\8�G�Z���Z��U�"S*�fiwӰX�m(�]4�Y��(D����*y�d��Z���*y�%���,�y�P�DQb�"�f,�7��v��"��i�M��sh����/�չ
������C�@��+������f�e��M.w�U�;��w�寅Y ���ڂͥ�{j��ǅ\����%RzW���.�ʝ����V���,ˆ�C߳�������ĸcNȮ���`:b|��ǅm��P�׫�4�c�ޖ�_�������N�V����7����Ng�����s����V�wYm=��'��ذ@#���;jR��jؚ̯y�w0��T�X`�YెHe�MU��D�2E��K)�z��Of�i�R[$n�b�p$�<�I?�1�-��TkH}�d/�Pn�T�{�q�QY�_]�¶���޺����	��r���26��h��j��D���B���� u|�7XS��
T��_.��}
��[��d�ћ'�`���2 �~�|�FIiR"������g�hԟ��� �Rq�
��fOt�ٙ�c��T����_��5]�"߯f39J��Kgw����s�s�M�k6�;����	|���3+^���?/��ϫSw6r��������*��I�������b�UUآl��s���m��o�^��[Ɔ��z#�����֡���?�r�Z�Uxd�m��
��|��������j����\=���
w��#�Z=���#�Y=�����X}����zh�*�	����_?��M�����⿣�~�_��<h� �k5M��>���������bag�}��9sH���x�1,��a�~H dd���z��̜�b�%�ج��Wd��"�q�����ɍ�c:�/��N�iE\ק��l��A� B_���z�+|���m�Z-��G��DSc�*���q����^�����ڙ�8Z��Qld�2��#�7M�?x���Yo^�5~�(����%�w=,b�(Y�i���!{�/$�5�*B���'��F��<o[�_���.M���>* �XnpV ���aڬfG�����*|���'�)��y�J�>-�tK�E�i��?�|�3�k�q��i��Z�e�|d�Ja�ߧ��zݳ'��:��9�q��ʬY�9��C�5��g֍��v~=���s�;/�����q��+ǵG�Pmߟ��fL6O��q��L�����aݫ���a�����f.�g(�����h\:���B�1/��~���9�5������{g]@%T��ɍ�gt�N �5��T��M���E�c�#BZ;��Ŷ`����F����w�9��,�1��a�|��Vjgg�FmĞrA3�Y�'{�Mg�x��_��Shҙg�K웏��ƪ`��ځZ���y�d`���)$�NPF�-L�Q(�%h�u}�J��^??-6�O�<�3/�����n����)�Tx1��e��k�i�Q�3�Kxj=��� ���
0���c��̐r����tx|�\���mX�5�X���?��p���ŏ���ԛ��pN���pf����?�@}[ y�B��s$ؤ�|O���%��>���[W�b
B�&]`	z@�8XS԰��]�$�X���)U�Ɵ	
R]��_��Z�����gP�!/V �+�u�΢j�T��� @6�����!l�U�hF��	X��aH$��
W�kl(�;j���@�A���%Rf)%O �+F<����Qp8�q�푈au�g\�Ŷ�k;�3���yZ�����'�bR�w�5Ź3�n<I.]��{#����D���h�ȎD�/�P4�|�� F�Ϭo�qO�����TD��gRC+]n۹ �	�쟢�ז�u��~����Ę��(+�T��M�S���5t���#�?�\�Ҧ2�����/�0<��T  m{b� ��H2)~��X(�
���3`�	8=.�0TQ�9;$����G>�縇Q�zݔ�����Ɓ�3���YH,+��1�ګg��[P�_�9~��:���7���`��2sp�;ǵ�WǠ9� �נݢfc�&s��
�g��{F�v�;(971a1|����q��%1$0�����6Hŉ���M��X�	r`��67�=)��hڮՀ� ��ڷϊ�Τf{�>�I-�����1�q4qS�8vC��U܇�!8�.��,�&/�V���^��LL�J�`c۝�n4�W��Σ+�e�S��\������!���m�9hy�M{�d�[�2}�c;��L�N�&�����QX偘)�hsK�i�F�<����P TV0��9���p��2f�I��#nŇ�sw.�	�k�/Jx�{��.4�v`U�f��6Մ>%@���#/�_����W��	�w�������cG���7a�ޯ��_�5�56O������� ��d�-Z��̾,R!g�ٙ�2Q��T$��$j�H��;J��G�5uz��h�P'�by�ȐPT���͵i�q�?U�L�������a���h��Ͽ��gG����\B�З�-�߰�Fv��� ���q�ۡ�w,���o0�Jr�s%�0���^��?i�Ć߱�	�r��Ai-�*3��o_������i�g#;}�������~���`fx���!J3	G@��6��ޞ�F���0,E�;Gj�|^�ş[YRm�X#�灺�{T%���e��OgQ�Z-X�ޠN��L���.i.�,&7��4u���0WB�aA2ұ�B������[�����jRL�3���!���׿�v�t�Yz	�	�7�T[X�-����P��ڃz���Sfi/F0���`�)�K�.YAb{���Q������o���,�����ߞ�˗})��&lߞ�9~�¸3�[
�y�@�݈�q�]���ŏ�h'r���-(e�(S���5D�3y��L^C$?�7���\��Ğ|D6�'��ن�J�|B�(D��g{"K�sW")���ٶ:k�l1?�&�����H��)O����zW"IӒ��O嗞)=�~v�%w<�����8�}G���N�v� �ׅ��;�,s��E�z���	Y��P��"7�́
��?�>� h6��ڮ+0ӟ�K�PEOm��]"���J� ����zx�8��$/���!��{����=���:����M�����bZ����?����bc������ը�������[��Mg4�ӱ&g2u��_�SE��;���A�=�a@"��6���m�����O{�n������Or�H�bK�Ҍ���e�j����l�_>��q ��*��.S��0˕�FPA?��7qnx>�׍��5�/��4��'w�|:�#*��'s"����^�}qA[������n���l:/�绒�o�Tߎ�a���Pm7	��q���~��+�e��0&J�.`X`3C��Yf�'-�"|�X����#��� 
����O^@ks�3����ݝx_���*�V.�+�	9�;ʹ�7|.}���q��[��жj�L�SF&��w�q��D�5`{m��h<N]������i�Kƽ�T���d�C'0x�(N��%Gr�qQ������3ƻ%C2M:��F���ĞF��_��F�ӄ*��n���u���[�	w��Q�'3=��#9E��#k&Ć�`X4-;r��e�o�ڋ)��fj�k �D�im�Z�3����_�&�^o6EY)��C�7��4&�A�M�$�X�
M',��.��s,N��vz?]��H/�y�Oz�K`_��<Mv�%>
A�>!�Ї��42I��КX#e���͟F#Z]ɅF�&��b�~����gk ��7�d�>. ��΂��{��yw6�&;�s��Z�O��{|�ʴ=�D�=HN}��(]�����?��,<�G6�O p�	��npO�f �-����4�Z���C[������t�����5$���(&���$�?�,2*aɃ{|�3k��;\{8�G���2�N�e�8t�@��`�XY�������ܬ�]_<��uG�d#XA�R0����,[�l0潢2��0iߖ0`�T�V�~G�_B��+��U$�DuM���>�0~��&�4��,�0RY7-��T�mO�������cQq�U��WL�ƣ�K 8,j��%���N�mr2� 
\��h�@�����b�^� ��.���=��:F�SQ7z�
�h���a�y�s���C+Ozcm^�u����S&���*���U>���Ѽ�l���c)�o��kxi߰ҿ�^ʗ�18�����#�
�����Ur���<o�k���Ez�8p0y!���36���t��v��x��H�x�顴����D��;�f��s��^�z�dR�\X������������f���x�
�/O�Z�0)5nv)LU�WB.�ē��`w�B'/��[#��8����BFz���k��x�&i��/d��d��D����9[��;�oWk8LO���*������ҙWB�c�9���:6��tF~�`�X>Jw�}ild���7sdL���i$�<:������=�L������{E��J��	��2�B1߁�8����S���p��i'���ř;��m����93r.4F����������@��Ã����Q�U�r]�)��іv�������ȴ�G�>ȦOn���Q�����;��z�������O<������#|k��,kuf�|�:h��8['����H
�Ƴ>�g���P�vEh+�P��8�fɄ�����ō,��_�>~��%�i���5
������T�eb���w�n�L�^��5r����F���z;�kK2<J�A��AY2�w/����37uδ��Jv����m�Y�ީ��7��*���Ko٭��q�#�r(�:��$)�@���I�p�+�F=�j�9c����JC{ࢉ̴X��=��.o��X��!��4�G�5��<Z�Մ�b��^� �1��uJƗex��*F�a��SQ��N��6G/V16}��w-�����{�m�W~�PYq��'mLxě��Mjrz�>xf����ܢ7wd���1�I�i�'|�����n�j>��?�.���Cem�pT&��Xڟ�~�D��Ռ����Y���k�fa&GA�LW�!#s�1����W1z����N��I��I?��'۬�E|�87����� 'g�<O"W_ZoJq܇�]Y«��Cy�aF��	�\�uKN\����\*�.�M"�ҭ������)YI��NvK�%&m_@c�tM�"�:#wS�:-� ���������~�7����%����QQ�=�ӗ��(gW!5���&��MuSFv{�,R��y���h/����DX��v�*ĸ�T�Y���:��pY�M2�nq1C<?�zt�;['�Y�Z�m~�楼�m�+~T؄q!)���N�����Q�b����geb��%R��Cq���S�M�PF��R�R*i��ސ�ྍ���X�}� nѪ��k��o��#�j/�
�<��q��8=aƻ�6�e007�|*=�;2s��>ܘ�R�rA�p<'�'v����1S4�KY�}d�.�&]��q�ɗ/ۻs���~}��J�Jef\&����V��#�H�2=�T�pEX*r���EY�z-�9d9V��0?�0/U��#͠[iA�!Ȩ�j~�Z%�(���(!�q�w���-��_`��5���vi�Oy�����.	���Jx�
 �Rl���.�p�Z7B]L"��^@�t�v�~I��]J�r�Ul"�e��%�-�)�C�|�LJ��j�J�8�n�8-�,m����<"[�^�k���6�����́e*���-< ���y%]����ՊqT�|9�*	�E*��TI�@�%3��]J6(䳘���'¿�\
��3�ZM]$dM�j���t}�q�$�l�TK��S�-��=��PB׵a�#i� U�8�Ϣt?�㊂�'p���,�
�-��׸����.�edjE�p�����)��]"����!�-��������m���+����S��4��^ۉo�8��涶�?J��eI�8n���w R�DJJ�^�m,�� ��i�A7��`Ct����F^�&���ps�Ⱐ�8��s)�lxUyr� m���u�j4��%�Oo"G��
���nfĆ�~�	��5u�u�".�B&�"�l�
|���S��{i: b�V-�>���bb΢�{a|�ƻ��;̅˻����x\�wa��'����?�F�/e|u�C��C����{���
�����1��Oč �-����9Fa�z�<�;�BlO�3�FbUQ�\�]���0���o�;�&%o�$h߶)�s<�/�ȡz�:~���ǲ~��F�r��y7T �N��R"�Hp�R�S� �����/-���s�^E~�XY�f��9{��(��!�:�{C�w�A�ڽBiq,� 4���3n�E��׃-jci�Q n·k�eҊ4�
��w]��J�)4� �=��q�@`*�*I�no��iZ��
 �lW)Wx�C��AHF��T�]�.���Xl�̓_Z㝀/�!���ω���TT�K�u�,��2�{�k�?q�v�*b�t�i5�:�V�;�ks~bB+2<�>*Ɇ����?a�B#g�: �À����T%��g�>72��(|���tW��=4�ܖj ��v��g#��|U0����B<�K,�Fa�m7�e��h9��f�ك?��"�
�"Ѡd��I컩(D� �%h�#�F����4;B�I�`e{�����.|�c^c4��1"�w"�7�u�t�YG��u�I���޾�8�{~��.�x�v���Yih�QD�x�R�0�ܔ�����[�TgNEj8"���]#�J2�ɫP�Q��OhY�>.Q�"hX�$�3�KL����#��:�0N[��|8�~�K<J S�6B�F����R|�zh��Ps�pmf8�w��x{8w23���L%s��ڦf�ZҤy"4?Y�G?v~P��2/j��d���ܼzs���������<9�y;l��TE3�~����0;(���9	lG��L��~��4���K/n��O�A�1�7���c�r���o\τv�F|�o~�yJ0w���(G������ц���3�%	�a!al,[ȁ�udx��-:C��^%`A	{k���M_xh�ah<@y��:C�"&��FĎJ;�ȼ8�P�`.EœJ2���V��,���8{��,�j��w�c�U,%��L��N�` hCf��U�o�-�d�p�a>���r��{��J`N(�%u�&����Q��Ϡ!���H�p�o�ą��<��<���#tr���ۚ��K� IS�t�1I%��e$;����nL���`���q ���YB�;W�  ��$ܧ�K�+�� I���g�yZj2�X�qXw���R�r����ۤ���֏T�H��6�۱�:��4�9����������_z����0v�Έ_?��+{�}�_I��W��#6��ֳ)�K�S�.��FS%�.�t⛄�U�!�-_FS�$�YI����jI��1����j�	���(��.n=�X��4I(-�L*/��������2���jv���t���4��T!i�X!i��Ӗ��JI#b���b� k�q۱J��
J��%��̒�8�+(*@��U���y�+,-(,�y�f��^�y�zy<\ �:V�Q!�5��ֺl(��F��AZ�j�k�,�8�)55����X�}����85~^��u.�d�Cm�o$�p�?�y���$녙M��IC{w7�e��bz����9�e��2�;Û�*HE8i����ȥ�V��f��&�e!Ȼu.Ϟ��h7}�6��9���*<9�&��6�AKQ�7��jѾ ������AI�y/U5١(jkp�s@ӽJ���1&�Mw	��R����+R}P4��������<�\`aӪ)��ز�`Aɒ����ocn�ßW���Ej��v��8�5f{
x�(K9Ŏ����E�z�/܎�s'����%U�V�9�x�q^)2�����c�{����>�7a7wH�p`.�8	r�Q���?�1���A�i6��~�i1��k����h��3���"�`<�M�u���>�d�t�ьK
k��6��V�I��z��v�<{�>��z�%[n�q��|�>{�~�yZ�ps�Eu�M}���	s��c�4폆�)-|�!U<�C:�U�Qу�����`V��3(T�5z�+�eY�}:)���b��Q�L�{��nј���YrZ�7d&��T{CgT�_H�ׄ�H�'X��F�W��@�'PJ�_\��=(��/���������t���E�}fJ�Ϯ��X�?��O�����*?�����T��"��V��	���!7�@�s�q%@�E�G�y��Q(v����\K�pvD�c�����4f Y�	�&~�n����ԍ$�(u���U��?��<��T�S� ���V��;����^�9�w������j�y[ǘT�Х�X +�ge��,�tf�D�3��E��%�:�%!U�w_Z߹��������H(Z~��Eb���"�ӇJ��6��Ѥx�ABzpL@���T;pV�:˔�c����jYq21A�/.���zΕ�n4ڧ>��j��T�Œ옼�Z�U�kwD˨f��A8�:��a|WC��OD�1bK��w5R�#�Vȫ�ꃓ���G���l{���D��oZ9\I���$������ ���Iӹ���U��{�Cug=	ٚz�������H�., �Y(����w�ո�M{҇T�:4��@��i᧧1�@��4^��ζE,H������p��xr�s�����F,Ű`�,�_Z��n9 �'�|������ǡvAe�#�-���谺	�HWF)Ot-����i���Ͽ4R`������D)�A�7$%ߨ�PT(�Jʑ����������#��;��Hs-��f�:gr�0BT�j��X�L����"�ȴ���ߪ�����a�Q<?/
���L�<�]�x^)�fS<�7 ��Ū!jm�>���94�@���F�3S��Y)]W�Λg������_K?���67���???y��><>�=�퀙���6k0�/�ZZj�L��ِ*WU�R��e�E�.���:�ѯƋ|2T�yM��:�:>W��TTKw�Σ]�Cz8�ף��4@�B�C�]d�
����Tv�+@K5<�U+�r�K��z�s���_o�W�S�K�$G�Qa�����Ly���I���v�����O�wA�����53��(����i�+����.��L}x� [����nʉ��F���	?��)�h(�	�b��Eq#�Ί���v�,)tp+vS�S[�&��PASxF1T1�v����=�.HV`��?*��dR�:�{)-Y�͐��{큪�t$��*�OZ�Y�F����<�h�5�.2�6��x��`���	*�3/���HEu#-vQ�o�Љ���.�J�,��2R))�e:�G�ZC��CZ�:����ӣ��#XJ��=��wF���V�uҽ���BQP1���"A�)t�������� ^���!��mO�;�o���?��{u�V	E�{�4P����x��G��/�0�@�S��a:y�L?<_6w�~\9��R	D�ԲReވ�J�{+�G�5�>��\����ax f�$<'���߃F�Xf(e��X�3*IT��n�YU��U�#Q��`]�4�HQ\�������=�A���+̬�����z=壽wo��H�}�<�:�gߊL�p�mc�.n�b�2n%j�R
�پR7�A!���x�	�C��j;b,eOC+	��J �׸��:+c�ѐ��n��5X#�E�b|��	�b^n�Kު����J���k�J�ѕ����.`�1��=x�g���@p�I&B��|�&�x@�{�6G�H E���+�_a5�(�Қ��T���o	G��I��n�H��ڞ���f+A�(i.�Լb�̤��Q��;�?���PA��*3�:T�u���Ȇ����'�kdꔋ,d���@�����n�l7m�-��Dz��E�Ұ�弔�TV�����e3s��Wૣt|5^��h�^[i��c+վ�jJ���Q�:Z�����*��`%�8K���$�߻B�F����x�>l��q�����)��[��9���(��ݦ.{%ᩡ�o�7�cq��pd!akY(��=$'�zT�Rs�{�"-0*3ٵ�)��V��n,�I퉡������y��M�ƂmB�iT���@^Ri�<�uQ1	����Y��-����|�6roBS��q�$�)���d�f�
{fV�.��r��!M'/#E-��-:��=�=�.���$��M\<Mii�i`���%ci&Q��Wr�t4����>G�gV`��`��
N�E��=mH�p��E��|�NJ����Q�ۅ�~	۾�곫���q_��*� �U�Zf�jSu��`�I���r_^ȼ�3p�v��%F�F�Y�i��9�~�]��d����k"e,���6�#k�4q3Z�K����8����a�C&���җ;�V�^�j|��Y����A9E/���N�d(7G(��t7�5��)}:��y�������Lu�8:����ٖ´����r  u�[�/�f��@o�&�������7�֑u��A���G�4�K�e�#*����EA�b�K�`������%͘7�,`�9��%��&�i��\r��b�4�q�������h ��<z$�`ճ�$�J��o��HC���3�R�w�\����\����[�W���S��4SѾ��k_���e��a�R��m�S�4�)�k���7��=x��S�RE�4��[ɗYXK�s��Y�-Y�Km�Q��D�\�R"mn+�����g�fX��]R�N���R3�>�	ͬ$�u�Z�:P� �N�xR����A����my���Բ�z��3�vA�� @~�]�iB��ƶ�x�9)|��/�����`����,T�ek����������W��b�dXȼ������pE����g$ʿ���m���&Va���+$�$���_�J�_ZU���m{�7pGއ�D8�+�]�n��鉞I� �~�Qچ�6ܞ����ϒ^�����Ǟ��^�Z�vAO�����1�ڐx���w�=��@�A?SM�*7�z�	�$z&|.��;�H8U̞�e`\19U�f��)��T�
�FC�����q+���km��i�
�pʯ�O������Ǡ��;�?݉�Zu��PM"�CA~�m�I�����eL�@� �X<�d ���!���~��П-8���/��A��:|Q((�	��#�
vB6l�J r�r^l�~f⯅�ٶ^Oϵ"��������O�.4I��\�`��tƉ|�+�^�?��=��������o�zn��?��?��?��?��?��?��?��?��?��?��?��?��?��?��?_���+�v 8 