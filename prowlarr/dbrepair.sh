
[ "$1" == "" ] && exit
DBSTATUS=$(sqlite3 "$1" "PRAGMA integrity_check")
if [ "$DBSTATUS" == "ok" ] ; then
    echo "DB ALREADY OK"
else
    echo "FIXING CORRUPT DB (status $DBSTATUS)"
    TMPDB=$1.tmp
    echo -e ".mode insert\n.dump" | sqlite3 "$1" > $TMPDB
    rm "$1"
    sed -i  "s/ROLLBACK; -- due to errors/COMMIT;/" $TMPDB
    sqlite3 "$1" < $TMPDB
    rm $TMPDB
    echo "DB FIXED"
fi
