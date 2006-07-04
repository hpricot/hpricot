module TestFiles
    Dir.chdir(File.dirname(__FILE__)) do
        Dir['files/*.{html,xhtml}'].each do |fname|
            const_set fname[%r!/(\w+)\.\w+$!, 1].upcase, IO.read(fname)
        end
    end
end
