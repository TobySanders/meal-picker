namespace MealPicker.Resources.Abstractions;

public class Recipe
{
    public string Title { get; init; }

    public Recipe(string title)
    {
        Title = title;
    }
}