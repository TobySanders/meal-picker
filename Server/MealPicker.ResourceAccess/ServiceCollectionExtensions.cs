using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;

namespace MealPicker.ResourceAccess;

public static class ServiceCollectionExtensions
{
    public static IServiceCollection TryAddRecipesRepository(this IServiceCollection services)
    {
        services.TryAddSingleton<IRecipesRepository, RecipesRepository>();
        return services;
    }
}
