CPATH='.;lib/hamcrest-core-1.3.jar;lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf testArea
git clone $1 student-submission
echo 'Finished cloning'
set -e
files=`find student-submission`
for file in $files
do
    if [[ $file == */ListExamples.java ]]
    then
        theFile=$file
    fi
done
echo 'the file is '$theFile

if [[ -f $theFile ]]
then
    echo "File is Found!"
else
    echo "There is no file called ListExamples.java in your repository"
    exit
fi

mkdir testArea
cp $theFile testArea/
cp TestListExamples.java testArea/
cp -r lib/ testArea/
echo "test files and library copied sucessfully"

cd testArea/

set +e
javac -cp $CPATH ListExamples.java 2>errorFile.txt
if [[ $? != 0 ]] 
then 
    echo "There was a compile error with your file. See the following output to learn why"
    echo `cat errorFile.txt`
    exit
fi
javac -cp $CPATH TestListExamples.java
java -cp $CPATH org.junit.runner.JUnitCore TestListExamples 1>testsRun.txt
if [[ $? != 0 ]]
then
    RESULTS=`grep 'Tests run*' testsRun.txt`
    TESTS=${RESULTS:11:1}
    FAILURES=${RESULTS:25:1}

    let SUCCESS=$TESTS-$FAILURES
    echo "Successful tests: "
    echo $SUCCESS
    echo "Total tests: "
    echo $TESTS
    echo "Failed tests: "
    echo $FAILURES
else
    echo "All tests passed!"
fi