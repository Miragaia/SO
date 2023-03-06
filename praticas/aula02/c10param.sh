echo "Introduza o nome para os ficheiros: "
read name
for i in 0{0..9}
do
    touch "$name$i.dat"
done