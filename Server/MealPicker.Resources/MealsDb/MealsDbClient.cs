using System.Threading.Tasks;
using Microsoft.Extensions.Options;
using Microsoft.Data.SqlClient;
using MealPicker.Resources.MealsDb.Configuration;

namespace MealPicker.Resources.MealsDb;

public class MealsDbClient : IMealsDbClient
{
    private readonly MealsDbOptions _options;
    public MealsDbClient(IOptions<MealsDbOptions> options)
    {
        _options = options.Value;
    }

    public async Task<SqlConnection> GetConnectionAsync()
    {
        var connection = new SqlConnection(_options.ConnectionString);
        await connection.OpenAsync();
        return connection;
    }
}
