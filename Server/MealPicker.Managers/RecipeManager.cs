using System.Collections.Generic;
using System.Threading.Tasks;
using MealPicker.ResourceAccess;
using MealPicker.Resources.Abstractions;

namespace MealPicker.Managers;

public class RecipeManager
{
    private readonly IRecipesRepository _recipesRepository;

    public RecipeManager(IRecipesRepository recipesRepository)
    {
        _recipesRepository = recipesRepository;
    }

    public async Task<IEnumerable<Recipe>> GetRecipesAsync()
    {
        return await _recipesRepository.GetRecipesAsync();
    }
}