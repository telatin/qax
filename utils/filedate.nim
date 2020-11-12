import os
import times

var
 file = "uuid"
 time =  getLastAccessTime(file)

echo time.type

echo time

echo format(time, "yyyy-MM-dd", utc())
echo format(time, "HH:mm:ss", utc())
