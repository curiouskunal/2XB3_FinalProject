
f = File.open("load.json", 'w')
f.write('{"Graphs":false, "Cutting":false, "Testing":false, "loading":false}' )
f.close
sleep(3)
f = File.open("load.json", 'w')
f.write('{"Graphs":true, "Cutting":false, "Testing":false, "loading":false}' )
f.close
sleep(1)
f = File.open("load.json", 'w')
f.write('{"Graphs":true, "Cutting":true, "Testing":false, "loading":false}' )
f.close
sleep(1)
f = File.open("load.json", 'w')
f.write('{"Graphs":true, "Cutting":true, "Testing":true, "loading":false}')
f.close
sleep(1)
f = File.open("load.json", 'w')
f.write('{"Graphs":true, "Cutting":true, "Testing":true, "loading":true}' )
f.close