import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

import static java.nio.charset.StandardCharsets.UTF_8;

public class Parser {

    public char[] parse(Path path){
        List<String> lines;
        try {
            lines = Files.readAllLines(path, UTF_8);
        } catch (IOException e) {
            throw new IllegalArgumentException("Файл не текстовый");
        }
        StringBuilder builder = new StringBuilder();
        for (String str : lines) {
            builder.append(str);
        }
        return builder.toString().toCharArray();
    }

    public List<String> group(int k, char[] chars){
        List<String> strings = new ArrayList<>();
        for(int i = 0; i <= chars.length-k; i++){
            int j = 0;
            StringBuilder sb = new StringBuilder();
            while(j < k){
                sb.append(chars[j + i]);
                j++;
            }
            strings.add(sb.toString());
        }
        return strings;
    }
}
