import org.springframework.jdbc.core.JdbcTemplate;

import javax.sql.DataSource;
import java.sql.PreparedStatement;

public class GenomeRepository {

    private final JdbcTemplate jdbcTemplate;
    public GenomeRepository(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }

    public void save(String genome, String table){
        jdbcTemplate.update(connection -> {
            String insert = "insert into genome_"+ table +"(genome) values (?)";
            PreparedStatement statement = connection.prepareStatement(insert, new String[] {"id"});

            statement.setString(1, genome);
            return statement;
        });
    }
}
