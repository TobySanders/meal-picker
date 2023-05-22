using System.Threading.Tasks;
using Microsoft.Data.SqlClient;

namespace MealPicker.Resources.MealsDb;

public interface IMealsDbClient
{
    Task<SqlConnection> GetConnectionAsync();
}
