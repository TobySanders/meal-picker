using System.Collections.Generic;
using System.Threading.Tasks;
using MealPicker.Resources.Abstractions;
using MealPicker.Resources.MealsDb.Tables;

namespace MealPicker.ResourceAccess
{
    public class RecipesRepository : IRecipesRepository
    {
        private readonly IRecipesTable _recipesTable;

        public RecipesRepository(IRecipesTable recipesTable)
        {
            _recipesTable = recipesTable;
        }

        public async Task<IEnumerable<Recipe>> GetRecipesAsync()
        {
            return await _recipesTable.GetRecipesAsync();
        }
    }
}
