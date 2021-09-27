import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;

import javax.sql.DataSource;
import java.sql.PreparedStatement;

public class ModelsRepository {
    //language=SQL
    private final String SQL_INSERT = "insert into model(name) values (?)";

    private final JdbcTemplate jdbcTemplate;

    public ModelsRepository(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }

    public void save(String model){
        KeyHolder keyHolder = new GeneratedKeyHolder();

        jdbcTemplate.update(connection -> {
            PreparedStatement statement = connection.prepareStatement(SQL_INSERT, new String[] {"id"});

            statement.setString(1, model);

            return statement;
        }, keyHolder);
    }
}
