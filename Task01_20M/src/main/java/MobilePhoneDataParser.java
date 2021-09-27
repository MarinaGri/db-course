import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class MobilePhoneDataParser {
    private final String catalogReg = ">.*? ([A-Za-z0-9 ]+) [0-9]+GB";

    public List<String> parseModels() throws IOException {
        List<String> listOfModels = new ArrayList<>();
        for(int i = 2; i < 40; i++){
            Document document = Jsoup.connect("https://www.svyaznoy.ru/catalog/phone/224/page-" + i).userAgent("Mozilla").get();
            String text = document.select("span.b-product-block__name").toString();
            Pattern pattern = Pattern.compile(catalogReg);
            Matcher matcher = pattern.matcher(text);
            while (matcher.find()){
                listOfModels.add(matcher.group(1));
            }
        }
        return listOfModels;
    }

}
