#! /bin/bash

testUsageInfoCalledWithNoArguments()
{
  output=$(./media-org)
  assertEquals "$output" "usage: ./media-org [directory to sort from] [destination directory]"
  assertEquals 0 $?
}

testExifToolExists()
{
  assertNotNull exif
}

testInvalidSourceDirectory()
{
  mkdir -p /tmp/destination

  source_directory="/tmp/non_existant"
  assertFalse "[ -d $source_directory ]"
  output=$(./media-org "$source_directory" "/tmp/destination")
  assertEquals 1 $?
  assertEquals "$output" "$source_directory is not a directory"

  rm -rf /tmp/destination
}

testInvalidDestinationDirectory()
{
  mkdir -p /tmp/source

  destination_directory="/tmp/non_existant"
  assertFalse "[ -d $destination_directory ]"
  output=$(./media-org "/tmp/source" "$destination_directory")
  assertEquals 1 $?
  assertEquals "$output" "$destination_directory is not a directory"

  rm -rf /tmp/source
}

testJpgSortingByEXIF()
{
  mkdir -p /tmp/source
  mkdir -p /tmp/dest

  cp ./test/assets/* /tmp/source/

  output=$(./media-org /tmp/source/ /tmp/dest/)

  assertEquals 0 $?

  # Directory Structure
  assertTrue "[ -d /tmp/dest/Photos/2015 ]"
  assertTrue "[ -d /tmp/dest/Photos/2015/09 ]"
  assertTrue "[ -d /tmp/dest/Photos/2014 ]"
  assertTrue "[ -d /tmp/dest/Photos/2014/03 ]"
  assertTrue "[ -d /tmp/dest/Photos/2014/07 ]"

  # File Targets
  assertTrue "[ -f /tmp/dest/Photos/2015/09/a.jpg ]"
  assertTrue "[ -f /tmp/dest/Photos/2014/03/b.jpg ]"
  assertTrue "[ -f /tmp/dest/Photos/2014/07/c.jpg ]"

  # Move
  assertFalse "[ -f /tmp/source/a.jpg ]"
  assertFalse "[ -f /tmp/source/b.jpg ]"
  assertFalse "[ -f /tmp/source/c.jpg ]"

  rm -rf /tmp/source /tmp/dest
}

testJpgSortingByFilename()
{
  mkdir -p /tmp/source
  mkdir -p /tmp/dest

  touch "/tmp/source/2015-09-03 01:10:39.jpg"
  touch "/tmp/source/2014-03-03 01:10:39.jpg"
  touch "/tmp/source/2014-07-03 01:10:39.jpg"

  output=$(./media-org /tmp/source/ /tmp/dest/)

  assertEquals 0 $?

  # Directory Structure
  assertTrue "[ -d /tmp/dest/Photos/2015 ]"
  assertTrue "[ -d /tmp/dest/Photos/2015/09 ]"
  assertTrue "[ -d /tmp/dest/Photos/2014 ]"
  assertTrue "[ -d /tmp/dest/Photos/2014/03 ]"
  assertTrue "[ -d /tmp/dest/Photos/2014/07 ]"

  # File Targets
  assertTrue "[ -f '/tmp/dest/Photos/2015/09/2015-09-03 01:10:39.jpg' ]"
  assertTrue "[ -f '/tmp/dest/Photos/2014/03/2014-03-03 01:10:39.jpg' ]"
  assertTrue "[ -f '/tmp/dest/Photos/2014/07/2014-07-03 01:10:39.jpg' ]"

  # Move
  assertFalse "[ -f '/tmp/source/2015-09-03 01:10:39.jpg' ]"
  assertFalse "[ -f '/tmp/source/2014-03-03 01:10:39.jpg' ]"
  assertFalse "[ -f '/tmp/source/2014-07-03 01:10:39.jpg' ]"

  rm -rf /tmp/source /tmp/dest
}

testJpgSortingByModifiedTime()
{
  mkdir -p /tmp/source
  mkdir -p /tmp/dest

  touch -t 201301010000 "/tmp/source/jan_1st_2013.jpg"
  touch -t 201306050000 "/tmp/source/june_5th_2013.jpg"
  touch -t 201412030000 "/tmp/source/dec_3rd_2014.jpg"


  output=$(SORT_BY_MODIFIED=true ./media-org /tmp/source/ /tmp/dest/)

  assertEquals 0 $?

  # Directory Structure
  assertTrue "[ -d /tmp/dest/Photos/2013 ]"
  assertTrue "[ -d /tmp/dest/Photos/2013/01 ]"
  assertTrue "[ -d /tmp/dest/Photos/2013/06 ]"
  assertTrue "[ -d /tmp/dest/Photos/2014 ]"
  assertTrue "[ -d /tmp/dest/Photos/2014/12 ]"

  # File Targets
  assertTrue "[ -f '/tmp/dest/Photos/2013/01/jan_1st_2013.jpg' ]"
  assertTrue "[ -f '/tmp/dest/Photos/2013/06/june_5th_2013.jpg' ]"
  assertTrue "[ -f '/tmp/dest/Photos/2014/12/dec_3rd_2014.jpg' ]"

  # Move
  assertFalse "[ -f '/tmp/source/jan_1st_2013.jpg' ]"
  assertFalse "[ -f '/tmp/source/june_5th_2013.jpg' ]"
  assertFalse "[ -f '/tmp/source/dec_3rd_2014.jpg' ]"

  rm -rf /tmp/source /tmp/dest
}

testVideoSortingByModifiedTime()
{
  mkdir -p /tmp/source
  mkdir -p /tmp/dest

  touch -t 201301010000 "/tmp/source/jan_1st_2013.mov"
  touch -t 201306050000 "/tmp/source/june_5th_2013.mp4"
  touch -t 201412030000 "/tmp/source/dec_3rd_2014.avi"

  output=$(./media-org /tmp/source/ /tmp/dest/)

  assertEquals 0 $?

  # Directory Structure
  assertTrue "[ -d /tmp/dest/Videos/2013 ]"
  assertTrue "[ -d /tmp/dest/Videos/2013/01 ]"
  assertTrue "[ -d /tmp/dest/Videos/2013/06 ]"
  assertTrue "[ -d /tmp/dest/Videos/2014 ]"
  assertTrue "[ -d /tmp/dest/Videos/2014/12 ]"

  # File Targets
  assertTrue "[ -f '/tmp/dest/Videos/2013/01/jan_1st_2013.mov' ]"
  assertTrue "[ -f '/tmp/dest/Videos/2013/06/june_5th_2013.mp4' ]"
  assertTrue "[ -f '/tmp/dest/Videos/2014/12/dec_3rd_2014.avi' ]"

  # Move
  assertFalse "[ -f '/tmp/source/jan_1st_2013.mov' ]"
  assertFalse "[ -f '/tmp/source/june_5th_2013.mov' ]"
  assertFalse "[ -f '/tmp/source/dec_3rd_2014.avi' ]"

  rm -rf /tmp/source /tmp/dest
}

testUnsortables()
{
  mkdir -p /tmp/source
  mkdir -p /tmp/dest

  touch "/tmp/source/unknown_date.txt"
  touch "/tmp/source/wat"

  output=$(./media-org /tmp/source/ /tmp/dest/)

  assertEquals 0 $?

  # Directory Structure
  assertTrue "[ -d /tmp/dest/Unsortable ]"

  # File Targets
  assertTrue "[ -f /tmp/dest/Unsortable/unknown_date.txt ]"
  assertTrue "[ -f /tmp/dest/Unsortable/wat ]"

  # Move
  assertFalse "[ -f /tmp/source/unknown_date.txt ]"
  assertFalse "[ -f /tmp/source/wat ]"

  rm -rf /tmp/source /tmp/dest
}

testFileDuplicationHandling()
{
  mkdir -p /tmp/source
  mkdir -p /tmp/dest/Photos/2014/03
  mkdir -p /tmp/dest/Photos/2014/07
  touch "/tmp/dest/Photos/2014/03/2014-03-03 01:10:39.jpg"
  touch "/tmp/dest/Photos/2014/07/2014-07-03 01:10:39.jpg"

  touch "/tmp/source/2014-03-03 01:10:39.jpg"
  touch "/tmp/source/2014-07-03 01:10:39.jpg"

  output=$(./media-org /tmp/source/ /tmp/dest/)

  assertEquals 0 $?

  # Directory Structure
  assertTrue "[ -d /tmp/dest/Photos/2014 ]"
  assertTrue "[ -d /tmp/dest/Photos/2014/03 ]"
  assertTrue "[ -d /tmp/dest/Photos/2014/07 ]"

  # File Targets
  assertTrue "[ -f '/tmp/dest/Unsortable/2014-03-03 01:10:39.jpg' ]"
  assertTrue "[ -f '/tmp/dest/Unsortable/2014-07-03 01:10:39.jpg' ]"

  # Move
  assertFalse "[ -f '/tmp/source/2014-03-03 01:10:39.jpg' ]"
  assertFalse "[ -f '/tmp/source/2014-07-03 01:10:39.jpg' ]"

  rm -rf /tmp/source /tmp/dest
}

if [ ! -f "./test/shunit2/source/2.1/src/shunit2" ]; then
  echo "You don't have the testing framework, make sure submodules are initialized:"
  echo ""
  echo "  git submodule update --init --recursive"
  exit 1
fi

# load shunit2
source ./test/shunit2/source/2.1/src/shunit2
