using Microsoft.Extensions.Options;
using Microsoft.Data.SqlClient;

namespace MealPicker.Resources.MealsDb.Configuration;

public class MealsDbOptionsValidator : IValidateOptions<MealsDbOptions>
{
    public ValidateOptionsResult Validate(string? name, MealsDbOptions options)
    {
        if (string.IsNullOrEmpty(options.ConnectionString))
        {
            return ValidateOptionsResult.Fail("ConnectionString must be provided.");
        }

        SqlConnectionStringBuilder builder = new(options.ConnectionString);
        if (builder.ConnectionString != options.ConnectionString)
        {
            return ValidateOptionsResult.Fail("ConnectionString is invalid.");
        }

        return ValidateOptionsResult.Success;
    }
}
