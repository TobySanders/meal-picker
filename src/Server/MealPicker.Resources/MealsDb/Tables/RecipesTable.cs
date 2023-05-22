using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;
using MealPicker.Resources.Abstractions;
using Microsoft.Data.SqlClient;

namespace MealPicker.Resources.MealsDb.Tables;

public class RecipesTable : IRecipesTable
{
    private readonly IMealsDbClient _client;

    public RecipesTable(IMealsDbClient client)
    {
        _client = client;
    }
    private static class StoredProcedures
    {
        public const string GetRecipes = "dbo.GetRecipes";
    }

    public async Task<IEnumerable<Recipe>> GetRecipesAsync()
    {
        using SqlConnection connection = await _client.GetConnectionAsync();
        using SqlCommand command = connection.CreateCommand();
        command.CommandType = CommandType.StoredProcedure;
        command.CommandText = StoredProcedures.GetRecipes;
        using SqlDataReader reader = await command.ExecuteReaderAsync();
        List<Recipe> recipes = new();
        while (await reader.ReadAsync())
        {
            recipes.Add(new Recipe(reader.GetString(0)));
        }
        return recipes;
    }
}
