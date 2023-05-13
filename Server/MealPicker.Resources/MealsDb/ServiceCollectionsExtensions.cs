using System;
using MealPicker.Resources.MealsDb.Configuration;
using MealPicker.Resources.MealsDb.Tables;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;

namespace MealPicker.Resources.MealsDb;

public static class ServiceCollectionsExtensions
{
    public static void TryAddMealsDb(this IServiceCollection services, Action<MealsDbOptions> configure)
    {
        services.TryAddSingleton<IMealsDbClient, MealsDbClient>();
        services.TryAddSingleton<IRecipesTable, RecipesTable>();
        services.Configure(configure);
    }
}