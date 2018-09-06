#!/bin/bash

# rg -g "*.h" -g "*.cc" -g "*.c" "${1}" --files-with-matches | xargs -n1 sed -n "s/${1}/${1}1/gp"


base_path=~/repos/chromium_ios/src

idx=1
for i in  `cat ${base_path}/symbol`
do
	let idx+=1;
	echo "idx is: ${idx} symbol is: ${i}"

	cd ${base_path}/third_party/boringssl/src/
# 	rg -g "*.h" -g "*.cc" -g "*.c" "${i}" --files-with-matches | xargs -n1 sed -n "s/${i}/${i}1/gp"
 	rg -g "*.h" -g "*.cc" -g "*.c" "${i}" --files-with-matches | xargs -n1 -I {} python ${base_path}/replace_whole_word.py {} ${i} ${i}z

	echo "---- replace boringssl ---"

	cd ${base_path}/net
 	rg -g "*.h" -g "*.cc" -g "*.c" "${i}" --files-with-matches | xargs -n1 -I {} python ${base_path}/replace_whole_word.py {} ${i} ${i}z
	echo "---- replace net ---"

	cd ${base_path}/crypto
 	rg -g "*.h" -g "*.cc" -g "*.c" "${i}" --files-with-matches | xargs -n1 -I {} python ${base_path}/replace_whole_word.py {} ${i} ${i}z
	echo "---- replace crypto ---"

	if [ `expr $idx % 50` -ne 0 ]; then
		 echo "---------------------------- replace success, does not compile: $i ---------------------------"
		 continue
        fi

	cd ${base_path}; ninja -C out/CronetX64 cronet_deps_complete;
	if [ $? -ne 0 ]; then
		echo "***************** replace failed: $i ************************"
		exit -1
	fi 
	
	echo "---------------------------- replace success: $i ---------------------------"
	echo $i >> /tmp/already_rename
done


cd ${base_path}; ninja -C out/CronetX64 cronet_deps_complete;
echo "----- done"

# rg -g "*.h" -g "*.cc" -g "*.c" "${1}" --files-with-matches | xargs -n1 sed -i '' "s/${1}/${1}1/g"

# echo "----- cd boringssl"

# cd third_party/boringssl/src/; rg -g "*.h" -g "*.cc" -g "*.c" "${1}" --files-with-matches | xargs -n1 sed -i '' "s/${1}/${1}1/g"

# echo "----- done"

