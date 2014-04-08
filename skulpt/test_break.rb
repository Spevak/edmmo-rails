trap('INT') {
  puts "hello"
  stop = 1
}

stop = 0

while true do
  if stop == 1 then
    break
  end
end
