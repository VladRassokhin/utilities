import java.util.zip.ZipEntry
import java.util.zip.ZipFile
import java.util.zip.ZipOutputStream

if (args.length < 3) {
    println "Required at least two arguments:"
    println "In case of duplicates, files from leftmost jar are taken"
    println "jar-merger from.jar [from.jar2, ...] out.jar"
    System.exit(1)
}

def out = args[args.length - 1]
def src = Arrays.asList(args).subList(0, args.length - 1)

def of = new File(out)
if (of.exists()) {
    of.delete()
}
if (!of.getParentFile().exists()) {
    of.getParentFile().mkdirs()
}
def zos = new ZipOutputStream(new FileOutputStream(of, false))
def putted = new HashSet<String>()

println "Output file is " + of.path

for (String path : src) {
    println "From file " + path

    def inf = new ZipFile(path)
    Enumeration<? extends ZipEntry> entries = inf.entries()
    while (entries.hasMoreElements()) {
        ZipEntry entry = entries.nextElement()
        def name = entry.name
        if (entry.isDirectory()) {
            continue
        }
        if (!putted.add(name)) {
            continue
        }
        println "\tAdding " + name
        zos.putNextEntry(entry.clone() as ZipEntry)
        def stream = inf.getInputStream(entry)
        zos << stream
        zos.closeEntry()
    }
}
zos.close()
