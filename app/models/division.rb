module DivisionData
  def get_division(division_id)
    sql = "SELECT id, name, age FROM divisions WHERE id = $1;"
    result = query(sql, division_id)
    tuple = result.first
    {
      id: tuple["id"],
      name: tuple["name"],
      age: tuple["age"]
    }
  end
  
  def edit_division(id, name, age)
    query("UPDATE divisions SET name = $1, age = $2 WHERE id = $3;", name, age, id)
  end
  
  def delete_division(id)
    query("DELETE FROM divisions WHERE id = $1;", id)
  end
  
    # Add a new division
  def add_division(name, age)
    sql = "INSERT INTO divisions (name, age) VALUES ($1, $2);"
    query(sql, name, age)
  end

  # Returns a list of all of the divisions ordered by their age
  def all_divisions
    results = query("SELECT * FROM divisions ORDER BY age;")

    results.map do |tuple|
      { id: tuple["id"].to_i,
        name: tuple["name"],
        age: tuple["age"] }
    end
  end
end