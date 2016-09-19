find ./ -name *.cc  | while read i
do
    echo "$i";
    mv $i.cc  $i.cc-backup
done
