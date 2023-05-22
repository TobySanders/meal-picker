using System.Collections.Generic;
using System.Threading.Tasks;
using MealPicker.Resources.Abstractions;

namespace MealPicker.ResourceAccess;

public interface IRecipesRepository
{
    Task<IEnumerable<Recipe>> GetRecipesAsync();
}