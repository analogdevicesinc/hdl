NAME=`basename $0`

mkdir -p run
mkdir -p vcd
iverilog -I.. ${SOURCE} -o run/run_${NAME} $1 || exit 1

cd vcd
../run/run_${NAME}
