#!/bin/sh

CHALLENGE=aoc-2019-day09-c01

do_build()
{
    exe_filename=${CHALLENGE}
    source_filename=${exe_filename}.S
    build_command="gcc -O0 -no-pie -Wall -nostdlib ${source_filename} -o ${exe_filename}"
    error_code=0
    if [ ! -e ${exe_filename} ]
    then
        echo ${build_command}
        ${build_command}
        error_code=$?
    else
        source_timestamp=$(stat --printf=%Y ${source_filename})
        exe_timestamp=$(stat --printf=%Y ${exe_filename})
        if [ ${exe_timestamp} -lt ${source_timestamp} ]
        then
            echo ${build_command}
            ${build_command}
            error_code=$?
        fi
    fi

    if [ $error_code -ne 0 ]
    then
        echo "failed to build"
        exit 1
    fi
}

do_clean()
{
    if [ -e ${CHALLENGE} ]
    then
        rm -v ${CHALLENGE}
    fi
}

do_run()
{
    ./${CHALLENGE} "${1}"
}

do_test()
{
    expected="${1}"
    str="${2}"
    if [ "${3}" != "" ]
    then
        str="${str} ${3}"
    fi
    cmd="./${CHALLENGE} ${str}"
    value=$($cmd)
    error_code=$?

    if [ $error_code -ne 0 ]
    then
        echo "KO: '${str}'"
        echo "program error code: $error_code"
        exit 1
    fi

    if [ "$expected" = "$value" ]
    then
        echo "OK: '${str}'"
    else
        echo "KO: '${str}'"
        echo "expected: ${expected}, got: ${value}"
        exit 1
    fi
}

do_test_batch()
{
    # day 5 part 1 unit tests
    do_test "00000000000000004" "4,0,99"
    do_test "00000000000000042" "104,42,99"
    do_test "00000000000001002" "1002,6,3,6,4,0,33"
    do_test "00000000000001002" "1002,6,-3,6,4,0,-33"
    do_test "00000000000001102" "1102,3,33,6,4,0,33"
    do_test "00000000000000002" "2,6,7,6,4,0,33,3"
    do_test "00000000000001001" "1001,6,3,6,4,0,96"
    do_test "00000000000001101" "1101,66,33,6,4,0,-1"
    do_test "00000000000000001" "1,6,3,6,4,0,93"
    do_test "00000000000000001" "3,0,4,0,99"
    do_test "00000000000000001" "103,0,4,1,99"
    do_test "$(echo 00000000000000004\\n00000000000000004)" "4,0,4,0,99"
    # day 5 for extra testing we allow an optional 3rd argument that will override program input default value
    do_test "00000000000000042" "3,0,4,0,99" "42"

    #  day 5 part 1 challgenge
    do_test "$(echo 00000000000000000\\n00000000000000000\\n00000000000000000\\n00000000000000000\\n00000000000000000\\n00000000000000000\\n00000000000000000\\n00000000000000000\\n00000000000000000\\n00000000016574641)" "3,225,1,225,6,6,1100,1,238,225,104,0,1101,61,45,225,102,94,66,224,101,-3854,224,224,4,224,102,8,223,223,1001,224,7,224,1,223,224,223,1101,31,30,225,1102,39,44,224,1001,224,-1716,224,4,224,102,8,223,223,1001,224,7,224,1,224,223,223,1101,92,41,225,101,90,40,224,1001,224,-120,224,4,224,102,8,223,223,1001,224,1,224,1,223,224,223,1101,51,78,224,101,-129,224,224,4,224,1002,223,8,223,1001,224,6,224,1,224,223,223,1,170,13,224,101,-140,224,224,4,224,102,8,223,223,1001,224,4,224,1,223,224,223,1101,14,58,225,1102,58,29,225,1102,68,70,225,1002,217,87,224,101,-783,224,224,4,224,102,8,223,223,101,2,224,224,1,224,223,223,1101,19,79,225,1001,135,42,224,1001,224,-56,224,4,224,102,8,223,223,1001,224,6,224,1,224,223,223,2,139,144,224,1001,224,-4060,224,4,224,102,8,223,223,101,1,224,224,1,223,224,223,1102,9,51,225,4,223,99,0,0,0,677,0,0,0,0,0,0,0,0,0,0,0,1105,0,99999,1105,227,247,1105,1,99999,1005,227,99999,1005,0,256,1105,1,99999,1106,227,99999,1106,0,265,1105,1,99999,1006,0,99999,1006,227,274,1105,1,99999,1105,1,280,1105,1,99999,1,225,225,225,1101,294,0,0,105,1,0,1105,1,99999,1106,0,300,1105,1,99999,1,225,225,225,1101,314,0,0,106,0,0,1105,1,99999,1008,677,226,224,102,2,223,223,1006,224,329,101,1,223,223,108,677,677,224,102,2,223,223,1005,224,344,101,1,223,223,107,677,677,224,1002,223,2,223,1005,224,359,101,1,223,223,1107,226,677,224,1002,223,2,223,1005,224,374,1001,223,1,223,1008,677,677,224,102,2,223,223,1006,224,389,1001,223,1,223,1007,677,677,224,1002,223,2,223,1006,224,404,1001,223,1,223,8,677,226,224,102,2,223,223,1005,224,419,1001,223,1,223,8,226,226,224,102,2,223,223,1006,224,434,101,1,223,223,1107,226,226,224,1002,223,2,223,1006,224,449,101,1,223,223,1107,677,226,224,102,2,223,223,1005,224,464,101,1,223,223,1108,226,226,224,102,2,223,223,1006,224,479,1001,223,1,223,7,677,677,224,1002,223,2,223,1006,224,494,101,1,223,223,7,677,226,224,102,2,223,223,1005,224,509,101,1,223,223,1108,226,677,224,1002,223,2,223,1006,224,524,101,1,223,223,8,226,677,224,1002,223,2,223,1005,224,539,101,1,223,223,1007,226,226,224,102,2,223,223,1006,224,554,1001,223,1,223,108,226,226,224,1002,223,2,223,1006,224,569,1001,223,1,223,1108,677,226,224,102,2,223,223,1005,224,584,101,1,223,223,108,226,677,224,102,2,223,223,1005,224,599,101,1,223,223,1007,226,677,224,102,2,223,223,1006,224,614,1001,223,1,223,1008,226,226,224,1002,223,2,223,1006,224,629,1001,223,1,223,107,226,226,224,1002,223,2,223,1006,224,644,101,1,223,223,7,226,677,224,102,2,223,223,1005,224,659,1001,223,1,223,107,677,226,224,102,2,223,223,1005,224,674,1001,223,1,223,4,223,99,226"

    ##  day 5 part 2 unit tests
    do_test "00000000000000000" "3,9,8,9,10,9,4,9,99,-1,8"
    do_test "00000000000000000" "3,9,8,9,10,9,4,9,99,-1,8 7"
    do_test "00000000000000001" "3,9,8,9,10,9,4,9,99,-1,8 8"
    do_test "00000000000000000" "3,9,8,9,10,9,4,9,99,-1,8 88"
    do_test "00000000000000001" "3,9,7,9,10,9,4,9,99,-1,8 0"
    do_test "00000000000000001" "3,9,7,9,10,9,4,9,99,-1,8 2"
    do_test "00000000000000001" "3,9,7,9,10,9,4,9,99,-1,8 4"
    do_test "00000000000000001" "3,9,7,9,10,9,4,9,99,-1,8 6"
    do_test "00000000000000000" "3,9,7,9,10,9,4,9,99,-1,8 8"
    do_test "00000000000000000" "3,9,7,9,10,9,4,9,99,-1,8 10"
    do_test "00000000000000000" "3,3,1108,-1,8,3,4,3,99 0"
    do_test "00000000000000000" "3,3,1108,-1,8,3,4,3,99 2"
    do_test "00000000000000000" "3,3,1108,-1,8,3,4,3,99 4"
    do_test "00000000000000000" "3,3,1108,-1,8,3,4,3,99 6"
    do_test "00000000000000001" "3,3,1108,-1,8,3,4,3,99 8"
    do_test "00000000000000000" "3,3,1108,-1,8,3,4,3,99 9"
    do_test "00000000000000001" "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9"
    do_test "00000000000000000" "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9" "0"
    do_test "00000000000000001" "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9 1"
    do_test "00000000000000001" "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9 2"
    do_test "00000000000000001" "3,3,1105,-1,9,1101,0,0,12,4,12,99,1"
    do_test "00000000000000000" "3,3,1105,-1,9,1101,0,0,12,4,12,99,1 0"
    do_test "00000000000000001" "3,3,1105,-1,9,1101,0,0,12,4,12,99,1 1"
    do_test "00000000000000001" "3,3,1105,-1,9,1101,0,0,12,4,12,99,1 2"
    do_test "00000000000000999" "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99"
    do_test "00000000000000999" "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99 7"
    do_test "00000000000001000" "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99 8"
    do_test "00000000000001001" "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99 9"

    #  day 5 part 2 challgenge
    do_test "00000000015163975" "3,225,1,225,6,6,1100,1,238,225,104,0,1101,61,45,225,102,94,66,224,101,-3854,224,224,4,224,102,8,223,223,1001,224,7,224,1,223,224,223,1101,31,30,225,1102,39,44,224,1001,224,-1716,224,4,224,102,8,223,223,1001,224,7,224,1,224,223,223,1101,92,41,225,101,90,40,224,1001,224,-120,224,4,224,102,8,223,223,1001,224,1,224,1,223,224,223,1101,51,78,224,101,-129,224,224,4,224,1002,223,8,223,1001,224,6,224,1,224,223,223,1,170,13,224,101,-140,224,224,4,224,102,8,223,223,1001,224,4,224,1,223,224,223,1101,14,58,225,1102,58,29,225,1102,68,70,225,1002,217,87,224,101,-783,224,224,4,224,102,8,223,223,101,2,224,224,1,224,223,223,1101,19,79,225,1001,135,42,224,1001,224,-56,224,4,224,102,8,223,223,1001,224,6,224,1,224,223,223,2,139,144,224,1001,224,-4060,224,4,224,102,8,223,223,101,1,224,224,1,223,224,223,1102,9,51,225,4,223,99,0,0,0,677,0,0,0,0,0,0,0,0,0,0,0,1105,0,99999,1105,227,247,1105,1,99999,1005,227,99999,1005,0,256,1105,1,99999,1106,227,99999,1106,0,265,1105,1,99999,1006,0,99999,1006,227,274,1105,1,99999,1105,1,280,1105,1,99999,1,225,225,225,1101,294,0,0,105,1,0,1105,1,99999,1106,0,300,1105,1,99999,1,225,225,225,1101,314,0,0,106,0,0,1105,1,99999,1008,677,226,224,102,2,223,223,1006,224,329,101,1,223,223,108,677,677,224,102,2,223,223,1005,224,344,101,1,223,223,107,677,677,224,1002,223,2,223,1005,224,359,101,1,223,223,1107,226,677,224,1002,223,2,223,1005,224,374,1001,223,1,223,1008,677,677,224,102,2,223,223,1006,224,389,1001,223,1,223,1007,677,677,224,1002,223,2,223,1006,224,404,1001,223,1,223,8,677,226,224,102,2,223,223,1005,224,419,1001,223,1,223,8,226,226,224,102,2,223,223,1006,224,434,101,1,223,223,1107,226,226,224,1002,223,2,223,1006,224,449,101,1,223,223,1107,677,226,224,102,2,223,223,1005,224,464,101,1,223,223,1108,226,226,224,102,2,223,223,1006,224,479,1001,223,1,223,7,677,677,224,1002,223,2,223,1006,224,494,101,1,223,223,7,677,226,224,102,2,223,223,1005,224,509,101,1,223,223,1108,226,677,224,1002,223,2,223,1006,224,524,101,1,223,223,8,226,677,224,1002,223,2,223,1005,224,539,101,1,223,223,1007,226,226,224,102,2,223,223,1006,224,554,1001,223,1,223,108,226,226,224,1002,223,2,223,1006,224,569,1001,223,1,223,1108,677,226,224,102,2,223,223,1005,224,584,101,1,223,223,108,226,677,224,102,2,223,223,1005,224,599,101,1,223,223,1007,226,677,224,102,2,223,223,1006,224,614,1001,223,1,223,1008,226,226,224,1002,223,2,223,1006,224,629,1001,223,1,223,107,226,226,224,1002,223,2,223,1006,224,644,101,1,223,223,7,226,677,224,102,2,223,223,1005,224,659,1001,223,1,223,107,677,226,224,102,2,223,223,1005,224,674,1001,223,1,223,4,223,99,226 5"

    #  day 9 part 1 unit test
    do_test "-0000000000000001" "4,3,99,-1"
    do_test "01125899906842624" "104,1125899906842624,99"
    do_test "01219070632396864" "1102,34915192,34915192,7,4,7,99,0"
    do_test "$(echo 00000000000000109\\n00000000000000001\\n00000000000000204\\n-0000000000000001\\n00000000000001001\\n00000000000000100\\n00000000000000001\\n00000000000000100\\n00000000000001008\\n00000000000000100\\n00000000000000016\\n00000000000000101\\n00000000000001006\\n00000000000000101\\n00000000000000000\\n00000000000000099)" "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99"

    # day 9 part 1 challenge
    do_test "00000002662308295" "1102,34463338,34463338,63,1007,63,34463338,63,1005,63,53,1101,0,3,1000,109,988,209,12,9,1000,209,6,209,3,203,0,1008,1000,1,63,1005,63,65,1008,1000,2,63,1005,63,904,1008,1000,0,63,1005,63,58,4,25,104,0,99,4,0,104,0,99,4,17,104,0,99,0,0,1101,0,608,1029,1102,1,29,1006,1101,39,0,1016,1101,1,0,1021,1101,37,0,1008,1101,0,25,1003,1102,32,1,1002,1101,0,35,1007,1102,1,28,1009,1101,0,31,1012,1101,22,0,1010,1101,319,0,1026,1102,1,23,1019,1102,423,1,1024,1101,27,0,1017,1101,0,36,1005,1101,0,0,1020,1101,681,0,1022,1102,1,30,1015,1101,0,24,1004,1102,312,1,1027,1102,1,21,1000,1102,1,34,1018,1101,0,678,1023,1101,0,38,1011,1102,1,418,1025,1102,1,20,1014,1101,33,0,1001,1101,0,26,1013,1102,1,613,1028,109,3,1202,5,1,63,1008,63,36,63,1005,63,205,1001,64,1,64,1105,1,207,4,187,1002,64,2,64,109,11,21108,40,40,0,1005,1014,229,4,213,1001,64,1,64,1105,1,229,1002,64,2,64,109,-19,1202,6,1,63,1008,63,33,63,1005,63,255,4,235,1001,64,1,64,1105,1,255,1002,64,2,64,109,3,1201,8,0,63,1008,63,29,63,1005,63,277,4,261,1106,0,281,1001,64,1,64,1002,64,2,64,109,10,21107,41,42,3,1005,1011,299,4,287,1106,0,303,1001,64,1,64,1002,64,2,64,109,19,2106,0,0,1001,64,1,64,1105,1,321,4,309,1002,64,2,64,109,-15,21107,42,41,-2,1005,1010,341,1001,64,1,64,1106,0,343,4,327,1002,64,2,64,109,6,2101,0,-9,63,1008,63,30,63,1005,63,363,1106,0,369,4,349,1001,64,1,64,1002,64,2,64,109,-11,1208,-5,29,63,1005,63,389,1001,64,1,64,1106,0,391,4,375,1002,64,2,64,109,15,1206,-2,409,4,397,1001,64,1,64,1105,1,409,1002,64,2,64,109,-3,2105,1,5,4,415,1105,1,427,1001,64,1,64,1002,64,2,64,109,-18,21101,43,0,10,1008,1011,42,63,1005,63,447,1106,0,453,4,433,1001,64,1,64,1002,64,2,64,109,19,1205,1,467,4,459,1105,1,471,1001,64,1,64,1002,64,2,64,109,-5,2107,34,-8,63,1005,63,489,4,477,1106,0,493,1001,64,1,64,1002,64,2,64,109,-11,2102,1,-1,63,1008,63,28,63,1005,63,517,1001,64,1,64,1105,1,519,4,499,1002,64,2,64,109,8,2108,37,-5,63,1005,63,539,1001,64,1,64,1106,0,541,4,525,1002,64,2,64,109,17,1206,-8,557,1001,64,1,64,1105,1,559,4,547,1002,64,2,64,109,-11,1205,2,571,1105,1,577,4,565,1001,64,1,64,1002,64,2,64,109,-14,1207,0,25,63,1005,63,599,4,583,1001,64,1,64,1105,1,599,1002,64,2,64,109,32,2106,0,-8,4,605,1105,1,617,1001,64,1,64,1002,64,2,64,109,-27,2102,1,-5,63,1008,63,24,63,1005,63,639,4,623,1105,1,643,1001,64,1,64,1002,64,2,64,109,-16,2101,0,10,63,1008,63,25,63,1005,63,669,4,649,1001,64,1,64,1105,1,669,1002,64,2,64,109,22,2105,1,8,1106,0,687,4,675,1001,64,1,64,1002,64,2,64,109,-21,1208,8,32,63,1005,63,705,4,693,1105,1,709,1001,64,1,64,1002,64,2,64,109,19,1207,-5,36,63,1005,63,729,1001,64,1,64,1105,1,731,4,715,1002,64,2,64,109,9,21101,44,0,-5,1008,1017,44,63,1005,63,753,4,737,1105,1,757,1001,64,1,64,1002,64,2,64,109,-12,21108,45,46,5,1005,1015,773,1105,1,779,4,763,1001,64,1,64,1002,64,2,64,109,-8,2108,25,1,63,1005,63,801,4,785,1001,64,1,64,1105,1,801,1002,64,2,64,109,-12,2107,22,10,63,1005,63,817,1106,0,823,4,807,1001,64,1,64,1002,64,2,64,109,23,1201,-8,0,63,1008,63,38,63,1005,63,847,1001,64,1,64,1106,0,849,4,829,1002,64,2,64,109,-3,21102,46,1,4,1008,1014,46,63,1005,63,871,4,855,1106,0,875,1001,64,1,64,1002,64,2,64,109,5,21102,47,1,2,1008,1017,46,63,1005,63,899,1001,64,1,64,1105,1,901,4,881,4,64,99,21101,0,27,1,21101,0,915,0,1105,1,922,21201,1,42136,1,204,1,99,109,3,1207,-2,3,63,1005,63,964,21201,-2,-1,1,21101,0,942,0,1106,0,922,21202,1,1,-1,21201,-2,-3,1,21101,0,957,0,1105,1,922,22201,1,-1,-2,1106,0,968,22101,0,-2,-2,109,-3,2105,1,0"
}

if [ $# -eq 0 ]
then
    do_build
    do_test_batch
elif [ "$1" = "clean" ]
then
    do_clean
else
    do_build
    for i in "$@"
    do
        do_run "$i"
    done
fi