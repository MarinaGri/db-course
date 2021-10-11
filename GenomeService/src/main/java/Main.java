import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import javax.sql.DataSource;
import java.io.IOException;
import java.nio.file.Path;
import java.util.List;
import java.util.Properties;

public class Main {
    public static void main(String[] args) {
        Parser parser = new Parser();
        char[] charsFromFile1 = parser.parse(Path.of("C:\\Users\\Marina\\Desktop\\test\\Genome_1-1.txt"));
        char[] charsFromFile2 = parser.parse(Path.of("C:\\Users\\Marina\\Desktop\\test\\Genome_2-1.txt"));

        Properties properties = new Properties();
        try {
            properties.load(ClassLoader.getSystemResourceAsStream("application.properties"));
        } catch (IOException e) {
            throw new IllegalArgumentException(e);
        }

        HikariConfig config = new HikariConfig();
        config.setDriverClassName(properties.getProperty("db.driver"));
        config.setJdbcUrl(properties.getProperty("db.url"));
        config.setUsername(properties.getProperty("db.user"));
        config.setPassword(properties.getProperty("db.password"));
        config.setMaximumPoolSize(Integer.parseInt(properties.getProperty("db.hikari.pool-size")));

        DataSource dataSource = new HikariDataSource(config);

        GenomeRepository genomeRepository = new GenomeRepository(dataSource);

        int[]nums = {2, 5, 9};
        for(int i = 0; i < nums.length; i++){
            List<String> stringsFromFile1 = parser.group(nums[i], charsFromFile1);
            List<String> stringsFromFile2 = parser.group(nums[i], charsFromFile2);

            for(String genome: stringsFromFile1){
                genomeRepository.save(genome, "first_" + nums[i]);
            }

            for(String genome: stringsFromFile2){
                genomeRepository.save(genome, "second_" + nums[i]);
            }
        }
    }
}

