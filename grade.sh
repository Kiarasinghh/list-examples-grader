CPATH=".:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar"

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'

if [ -f 'student-submission/ListExamples.java' ]; then
    echo "Files Found"
else 
    echo "File ListExamples.java not found!"
    exit 1
fi 

cp student-submission/ListExamples.java grading-area/
cp TestListExamples.java grading-area/
cp -r lib grading-area

cd grading-area

javac -cp ".;lib/hamcrest-core-1.3.jar;lib/junit-4.13.2.jar" *.java

if [ $? -ne 0 ]; then
    echo complication error 
    exit 1
fi

echo program compiled successfully 

java -cp ".:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar *.java" org.junit.runner.JUnitCore TestListExamples >JunitOutput.txt 2>&1
ls .
cat JunitOutput.txt

grep "Tests run:" JunitOutput.txt  > testsRun.txt

if grep -q "OK" JunitOutput.txt; then
    echo "100%! Good job"
else
    # Extracting numbers using grep and awk
    test_run=$(grep -o 'Tests run: [0-9]*' testsRun.txt | awk '{print $3}')
    failures=$(grep -o 'Failures: [0-9]*' testsRun.txt | awk '{print $2}')

    # Calculating percentage
    if [[ $test_run -ne 0 ]]; then
        pass_percentage=$((passes * 100 / test_run))
    else
        pass_percentage=0
    fi
fi

echo "Percentage of passing tests: $pass_percentage%"



# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests
