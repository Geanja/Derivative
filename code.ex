defmodule Derivatan do

  @type literal() :: {:num, number()} | {:var, atom()}
  @type expr() :: {:add, expr(), expr()}
    | {:mul, expr(), expr()}
    | literal()
    | {:exp, expr(), literal()}
    | {:sin, expr()}
    | {:cos, expr()}
    | {:sinn, expr()}
    | {:cosn, expr()}
    | {:ln, expr()}
    | {:div, expr(), expr()}


  def test1() do
    e = {:add,
          {:mul, {:num, 2}, {:var, :x}},
          {:num, 4}}
    d = deriv(e, :x)
    c = calc(d, :x, 5)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simp derivative: #{pprint(simp(d))}\n")
    IO.write("calc: #{pprint(simp(c))}\n")
    :ok
  end

  def test2() do
    e = {:add,
          {:exp, {:var, :x}, {:num, -1}},
          {:num, 4}}
    d = deriv(e, :x)
    c = calc(d, :x, 4)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simp derivative: #{pprint(simp(d))}\n")
    IO.write("calc: #{pprint(simp(c))}\n")
    :ok
  end

  def test3() do
    e = {:add,
          {:exp, {:cos, {:add, {:num, 5}, {:var, :x}}}, {:num, 2}},
          {:num, 4}}
    d = deriv(e, :x)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simp derivative: #{pprint(simp(d))}\n")
    :ok
  end


  def test4() do
    e = {:add,
          {:ln, {:exp, {:var, :x}, {:num, 2}}},
          {:num, 4}}
    d = deriv(e, :x)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simp derivative: #{pprint(simp(d))}\n")
    :ok
  end

  def deriv({:num, _}, _) do {:num, 0} end

  def deriv({:var, v}, v) do {:num, 1} end

  def deriv({:var, _}, _) do {:num , 0} end

  def deriv({:mul, e1, e2}, v) do
    {:add, {:mul, deriv(e1, v), e2}, {:mul, deriv(e2, v), e1}} end

  def deriv({:add, e1, e2}, v) do
    {:add, deriv(e1, v), deriv(e2, v)} end

  def deriv({:exp, e, {:num, n}}, v) do
    {:mul, {:mul, {:num, n} , {:exp, e, {:num, n-1}}}, deriv(e, v)}
  end

  def deriv({:sin, e}, v) do
    {:mul, {:cos, e}, deriv(e, v)}
  end

  def deriv({:cos, e}, v) do
    {:mul, {:sinn, e}, deriv(e, v)}
  end

  def deriv({:sinn, e}, v) do
    {:mul, {:cosn, e}, deriv(e, v)}
  end

  def deriv({:cosn, e}, v) do
    {:mul, {:sin, e}, deriv(e, v)}
  end

  def deriv({:ln, e}, v) do
    {:mul, {:div, {:num, 1}, e}, deriv(e, v)}
    #{:mul, {:exp, e, {:num, -1}, deriv(e, v)}}
  end

  def calc({:num, n}, _, _) do {:num, n} end
  def calc({:var, v}, v, n) do {:num, n} end
  def calc({:var, v}, _, _) do {:var, v} end
  def calc({:add, e1, e2}, v, n) do {:add, calc(e1, v , n), calc(e2, v , n)} end
  def calc({:mul, e1, e2}, v, n) do {:mul, calc(e1, v , n), calc(e2, v , n)} end
  def calc({:exp, e1, e2}, v, n) do {:exp, calc(e1, v , n), calc(e2, v , n)} end



    def simp ({:add, e1, e2}) do simp_add(simp(e1), simp(e2)) end
    def simp ({:mul, e1, e2}) do simp_mul(simp(e1), simp(e2)) end
    def simp ({:exp, e1, e2}) do simp_exp(simp(e1), simp(e2)) end
    def simp ({:cos, e1, e2}) do simp_cos(simp(e1), simp(e2)) end
    def simp ({:sinn, e1, e2}) do simp_sinn(simp(e1), simp(e2)) end
    def simp ({:cosn, e1, e2}) do simp_cosn(simp(e1), simp(e2)) end
    def simp ({:sin, e1, e2}) do simp_sin(simp(e1), simp(e2)) end
    def simp (e) do e end


    def simp_add(e1, {:num, 0}) do e1 end
    def simp_add({:num, 0}, e2) do e2 end
    def simp_add({:num, n1}, {:num, n2}) do {:num, n1+n2} end
    def simp_add(e1 , e2) do {:add, e1, e2} end

    def simp_mul(_, {:num, 0}) do {:num, 0} end
    def simp_mul({:num, 0}, _ ) do {:num, 0} end

    def simp_mul(e1, {:num, 1}) do e1 end
    def simp_mul({:num, 1}, e2) do e2 end

    def simp_mul({:num, n1}, {:num, n2}) do {:num, n1*n2} end
    def simp_mul(e1, e2) do {:mul, e1, e2} end

    def simp_exp(_, {:num, 0}) do {:num, 1} end
    def simp_exp(e1, {:num, 1}) do e1 end
    def simp_exp({:num, n1}, {:num, n2}) do {:num, :math.pow(n1, n2)} end
    def simp_exp(e1, e2) do {:exp, e1, e2} end

    def simp_cos(e1, e2) do {:cos, e1 ,e2} end
    def simp_sinn(e1, e2) do {:sinn, e1 ,e2} end
    def simp_cosn(e1, e2) do {:cosn, e1 ,e2} end
    def simp_sin(e1, e2) do {:sin, e1 ,e2} end




    def pprint({:num, n}) do "#{n}" end

    def pprint({:var, v}) do "#{v}" end

    def pprint({:add, e1, e2}) do "(#{pprint(e1)} + #{pprint(e2)})" end

    def pprint({:mul, e1, e2}) do "#{pprint(e1)} * #{pprint(e2)}" end

    def pprint({:exp, e1, e2}) do "(#{pprint(e1)})^(#{pprint(e2)})" end

    def pprint({:sin, e}) do "sin(#{pprint(e)})" end

    def pprint({:cos, e}) do "cos(#{pprint(e)})" end

    def pprint({:sinn, e}) do "-sin(#{pprint(e)})" end

    def pprint({:cosn, e}) do "-cos(#{pprint(e)})" end

    def pprint({:ln, e}) do "ln(#{pprint(e)})" end

    def pprint({:div, e1, e2}) do "#{pprint(e1)}/(#{pprint(e2)})" end


end
