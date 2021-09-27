import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import javax.sql.DataSource;
import java.io.IOException;
import java.util.List;
import java.util.Properties;

public class App {
    public static void main(String[] args) throws IOException {
        MobilePhoneDataParser mobDataParser = new MobilePhoneDataParser();
        List<String> models = mobDataParser.parseModels();
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

        ModelsRepository modelsRepository = new ModelsRepository(dataSource);
        for(String model: models){
            modelsRepository.save(model);
        }
    }
}
