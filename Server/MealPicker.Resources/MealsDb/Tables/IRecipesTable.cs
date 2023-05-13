using System.Collections.Generic;
using System.Threading.Tasks;
using MealPicker.Resources.Abstractions;

namespace MealPicker.Resources.MealsDb.Tables;

public interface IRecipesTable
{
    Task<IEnumerable<Recipe>> GetRecipesAsync();
}
