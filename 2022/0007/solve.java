import java.util.*;
import java.util.regex.*;  

abstract class FSEntity {
    public String name;
    public Directory parent = null;
    abstract public int getSize();
    public String fullname() {
        String qualname = "/" + name;
        if (parent != null) {
            qualname = parent.fullname() + qualname;
        }
        return qualname;
    }
}

class File extends FSEntity {
    private int size;
    File(String fname, int fsize, Directory fparent) {
        size = fsize;
        name = fname;
        parent = fparent;
    }
    public int getSize() {
        return size;
    }
}

class Directory extends FSEntity{
    Map<String, Directory> children;
    Map<String, File> files;
    Directory(String dname, Directory dparent) {
        name = dname;
        children = new HashMap<String, Directory>();
        files = new HashMap<String, File>();
        parent = dparent;

    }
    public String toString() {
        if (parent == null) {
            return "/";
        }
        return parent.toString() + name + "/";
    }
    public int getSize() {
        int size = 0;
        for (Directory child : children.values()) {
            size += child.getSize();
        }
        for (File file : files.values()) {
            size += file.getSize();
        }
        return size;
    }

    public Directory getOrCreateSubdirectory(String name) {
        Directory child = children.get(name);
        if (child == null) {
            Directory subdir = new Directory(name, this);
            children.put(name, subdir);
            return subdir;
        } else {
            return child;
        }
    }

    public void addFile(String name, int size) {
        files.put(name, new File(name, size, this));
    }

    public ArrayList<Directory> getDescendants() {
        ArrayList<Directory> descendants = new ArrayList<Directory>();
        descendants.add(this);
        for (Directory subdir : children.values()) {
            if (subdir == null) {
                System.out.println(this.name);
            }
            descendants.addAll(subdir.getDescendants());
        }
        return descendants;
    }

    public ArrayList<Directory> getDirectoriesAtMostSize(int threshold) {
        ArrayList<Directory> dirs = new ArrayList<Directory>();
        for (Directory dir : this.getDescendants()) {
            if (dir.getSize() <= threshold) {
                dirs.add(dir);
            }
        }
        return dirs;
    }
    public ArrayList<Directory> getDirectoriesAtLeastSize(int threshold) {
        ArrayList<Directory> dirs = new ArrayList<Directory>();
        for (Directory dir : this.getDescendants()) {
            if (dir.getSize() >= threshold) {
                dirs.add(dir);
            }
        }
        return dirs;
    }
}


class Solve {
    public static void main(String[] args) throws Exception{
        Scanner scanner = new Scanner(System.in);

        Directory root = new Directory("/", null);
        Directory cur = null;
        while (scanner.hasNextLine()) {
            String line = scanner.nextLine().strip();
            String[] tokens = line.split(" ");
            switch (tokens[0]) {
                case "$": {
                    switch (tokens[1]) {
                        case "ls": continue;
                        case "cd": switch (tokens[2]) {
                            case "..": {
                                cur = cur.parent;
                                continue;
                            }
                            case "/": {
                                cur = root;
                                continue;
                            }
                            default: {
                                cur = cur.getOrCreateSubdirectory(tokens[2]);
                                continue;
                            }
                        }
                    }
                }
                case "dir": continue;
                default: {
                    Integer size = Integer.parseInt(tokens[0]);
                    String name = tokens[1];
                    cur.addFile(name, size);
                }
            }
        }
        scanner.close();
        // Part 1
        Integer acc = 0;
        root.getDirectoriesAtMostSize(100000);
        for (Directory dir : root.getDirectoriesAtMostSize(100000)) {
            acc += dir.getSize();
        }
        System.out.printf("Part 1: %d\n", acc);
        int freeSpace = 70000000 - root.getSize();
        int goalSize = 30000000 - freeSpace;
        Directory smallest = null;
        for (Directory dir: root.getDirectoriesAtLeastSize(goalSize)) {
            if (smallest == null) {
                smallest = dir;
            } else if (dir.getSize() < smallest.getSize()) {
                smallest = dir;
            }
        }
        System.out.printf("Part 2: (%s) %d\n", smallest.toString(), smallest.getSize());

        
    }
}