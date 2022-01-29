import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import javax.sql.DataSource;
import java.sql.PreparedStatement;

public class GenomeRepository {

    //language=SQL
    private static final String SQL_SELECT_FROM_TABLE = "select * from genome_first_5";

    //language=SQL
    private static final String SQL_SELECT_FROM_VIEW = "select * from v_genome_first_5";

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

    public void selectFromTable(){
        jdbcTemplate.update(SQL_SELECT_FROM_TABLE, fakeRowMapper);
    }

    public void selectFromView(){
        jdbcTemplate.update(SQL_SELECT_FROM_VIEW, fakeRowMapper);
    }

    private final RowMapper<Object> fakeRowMapper = (row, rowNumber) -> {
        return new Object();
    };

}
