# 매트랩 클래스 튜토리얼 및 팁 정리
* 게으른맽랩

### 목차

1. [클래스 만들기](#클래스-만들기)
2. [Property의 기본값 설정](#property의-기본값-설정)
3. [Property에 Validation 추가하기](#property에-validation-추가하기)
4. [객체의 배열 만들기](#객체의-배열-만들기)
5. [handle class와 value class](#handle-class와-value-class)
6. [객체의 복사](#객체의-복사)
7. [Dependent property와 get method](#dependent-property와-get-method)
8. [Set method](#set-method)
9. [연산자 오버로딩](#연산자-오버로딩)
10. [내장함수 오버로딩](#내장함수-오버로딩)

# **클래스 만들기**

아래는 간단한 직사각형 클래스 예제이다. 

```matlab
classdef rect
    properties
        width
        height
    end

    methods
        function obj = rect(width,height)
            obj.width = width;
            obj.height = height;
        end
    end
end
```

클래스와 이름이 같은 메서드는 생성자(Constructor)로, 인스턴스를 만들 때 호출된다. 생성자가 필수는 아니다. 하지만 생성자를 두는 것이 일반적이므로, 생성자가 없는 경우는 다루지 않겠다.


```matlab
>> a = rect(3,4)
a = 
  rect with properties:

     width: 3
    height: 4
```

---

# **Property의 기본값 설정**

인스턴스 생성 시 property의 기본값을 설정해둘 수 있다. 두 가지 방법이 있다. 

## **방법 1. properties 블록에서 기본값 지정**

```matlab
classdef rect
    properties
        width = 3
        height = 4
    end

    methods
        function obj = rect()
        end
    end
end
```

```matlab
>> a = rect()
a = 
  rect with properties:

     width: 3
    height: 4
```

기본값에는 표현식도 쓸 수 있다. 하지만 변수는 포함할 수 없다. 이 방법은 무조건 주어진 기본값으로만 초기화된다는 불편함이 있다. 



## **방법 2. 생성자에서 [arguments](https://www.mathworks.com/help/matlab/ref/arguments.html) 사용**

```matlab
classdef rect
    properties
        width
        height
    end

    methods
        function obj = rect(width, height)
            arguments
                width (1,1) double {mustBePositive} = 3
                height (1,1) double {mustBePositive} = 4
            end
            obj.width = width;
            obj.height = height;
        end
end
end
```

```matlab
>> a = rect()
a = 
  rect with properties:

     width: 3
    height: 4
>> b = rect(1,2)
b = 
  rect with properties:

     width: 1
    height: 2
```


이 방법을 쓸 경우 properties 블록에서 기본값을 지정해도 무시된다. 정확히 말하면, 생성자 실행 전에 properties 블록에서 기본값을 지정하지만, 곧바로 생성자에서 덮어쓰므로 properties 블록에 쓰는 기본값은 의미가 없게 된다. 동작 순서는 breakpoint를 적절히 걸어보면 알 수 있다.

주의할 점이 하나 있다. arguments 블록에서의 Validation은 생성자에서만 동작한다. 

```matlab
>> a = rect()
a = 
  rect with properties:

     width: 3
    height: 4
>> a.width = @sin
a = 
  rect with properties:

     width: @sin
    height: 4
```

width에 엉뚱한 값이 들어갔지만 걸러내지 못했다. 생성자의 Validation은 생성자에서만 동작하기 때문이다. 그렇다면 width와 height에 비정상적인 값이 들어가지 못하도록 원천적으로 방어하려면 어떻게 해야 할까?

---


# **Property에 Validation 추가하기**

Properties 블록에서도 Validation을 부여할 수 있다. 

```matlab
classdef rect
    properties
        width (1,1) double {mustBePositive} = 1
        height (1,1) double {mustBePositive} = 1
    end

    methods
        function obj = rect(width, height)
            arguments
                width (1,1) double {mustBePositive} = 3
                height (1,1) double {mustBePositive} = 4
            end
            obj.width = width;
            obj.height = height;
        end
    end
end
```

```matlab
>> a = rect()
a = 
  rect with properties:

     width: 3
    height: 4
>> b = rect(1,2)
b = 
  rect with properties:

     width: 1
    height: 2
```

Validation은 Size, Class, Function으로 구성된다. 자세한 내용은 [문서](https://www.mathworks.com/help/matlab/matlab_oop/validate-property-values.html)를 보자. (참고: [Validation Function의 종류](https://www.mathworks.com/help/matlab/matlab_prog/argument-validation-functions.html))위 예시의 경우 width와 height는 scalar여야 하고, double이거나 double로 변환 가능한 자료형이어야 하고, 값은 양수여야 한다. 0 또는 음수 길이는 허용하지 않겠다는 뜻이다. 이 조건에 위배되는 값들은 할당할 수 없다.

```matlab
>> a.height = -1
Error setting property 'height' of class 'rect'. Value must be nonnegative. 
>> a.height = @sin
Error setting property 'height' of class 'rect'. Value must be of type double or be convertible to double. 
>> a.height = rand(3)
Error setting property 'height' of class 'rect'. Value must be a scalar.
```

주의할 점이 있다. 어차피 arguments로 기본값을 부여할 건데 왜 properties 블록에서도 기본값을 지정했을까? 이유가 있다. 아래 코드를 보자. 동일한 코드에서 properties 블록에서의 기본값 지정만 뺐다.

```matlab
classdef rect
    properties
        width (1,1) double {mustBePositive}
        height (1,1) double {mustBePositive}
    end

    methods
        function obj = rect(width, height)
            arguments
                width (1,1) double {mustBePositive} = 3
                height (1,1) double {mustBePositive} = 4
            end
            obj.width = width;
            obj.height = height;
        end
    end
end
```

아무 문제 없어보인다. 하지만 인스턴스 생성 시 에러가 발생한다.

```matlab
>> a = rect()
Error using implicit default value of property 'width' of class 'rect'. Value must be positive.
>> a = rect(3,4)
Error using implicit default value of property 'width' of class 'rect'. Value must be positive.
```

이유가 뭘까? 생성자가 호출되기 전에 인스턴스가 생성되면서 property인 width와 height 또한 자동으로 만들어진다. 그리고 기본값은 빈 배열이 된다. 빈 배열이 Validation을 통과하지 못하기 때문에 에러가 발생한다. 따라서 어차피 사라질 값이더라도 Validation 뒤에 Validation을 만족하는 기본값을 써주어야 한다. 

---


# **객체의 배열 만들기**

1 x 5 크기의 rect 배열을 만들고 싶다면? 세 가지 방법이 있다.

## **방법 1. for문을 사용**

```matlab
arr = rect.empty(0, 5);

for i=1:5
    arr(i) = rect();
end
```

## **방법 2. arrayfun을 사용**
```matlab
arr = arrayfun(@(~) rect, 1:5);
```

## **방법 3. 인덱스에 의한 자동 배열 생성을 사용**

```matlab
arr(5) = rect();
```

주의할 것이 하나 있다. 방법 3의 경우, 각 인스턴스는 아래와 같이 생성된다.
1. `arr(end)`에 들어갈 rect를 생성한다.
2. `arr(1)`에 들어갈 rect를 생성한다.
3. `arr(1)`을 deepcopy 하여 `arr(2:end-1)`에 집어넣는다.

동작을 확인하기 위해 rect 클래스를 아래와 같이 바꿔보았다.

```matlab
classdef rect
    properties
        width (1,1) double {mustBePositive} = 1
        height (1,1) double {mustBePositive} = 1
    end

    methods
        function obj = rect(width, height)
            arguments
                width (1,1) double {mustBePositive} = rand
                height (1,1) double {mustBePositive} = rand
            end
            obj.width = width;
            obj.height = height;
        end
    end
end
```

```
>> arr.width
ans =
    0.7691
ans =
    0.7691
ans =
    0.7691
ans =
    0.7691
ans =
    0.8878
```

방법 1, 2에서는 각 인스턴스를 개별적으로 생성하므로 이런 일이 발생하지 않는다. [Property 초기화에 대한 페이지](https://www.mathworks.com/help/matlab/matlab_oop/initialize-property-values.html)를 보면 아래 설명을 볼 수 있다.

> MATLAB evaluates a default expression when the property value is first needed (for example, when the class is first instantiated). The same default value is then used for all instances of a class. MATLAB does not reevaluate the default expression unless the class definition is cleared from memory.

다행히도 첫 번째 객체의 deepcopy이므로 값만 같을 뿐 실제로는 같은 객체가 아니다. Property중 아무거나 값을 바꿔보면 확인해볼 수 있다. 

---


# **handle class와 value class**

rect 클래스에 메서드를 하나 추가해보자. 자신을 1 x 1의 단위 사각형으로 바꾸는 메서드이다.


```matlab
classdef rect
    properties
        width (1,1) double {mustBePositive} = 1
        height (1,1) double {mustBePositive} = 1
    end

    methods
        function obj = rect(width, height)
            arguments
                width (1,1) double {mustBePositive} = 3
                height (1,1) double {mustBePositive} = 4
            end
            obj.width = width;
            obj.height = height;
        end

        function obj = make_unit_square(obj)
            obj.width = 1;
            obj.height = 1;
        end
    end
end
```

```matlab
>> a = rect()
a = 
  rect with properties:

     width: 3
    height: 4
>> make_unit_square(a)
ans = 
  rect with properties:

     width: 1
    height: 1
>> a
a = 
  rect with properties:

     width: 3
    height: 4
```

`make_unit_square`를 호출했는데 a는 바뀌지 않았다. 메서드를 호출하는 방법은 두 가지가 있다. method(instance)와 instance.method()이다. 두 번째 방법으로도 호출해보자.

```matlab
>> a.make_unit_square()
ans = 
  rect with properties:

     width: 1
    height: 1
>> a
a = 
  rect with properties:

     width: 3
    height: 4
```

여전히 바뀌지 않았다. 해결하려면 아래와 같이 두 곳을 바꿔야 한다. 맨 첫 줄, 그리고 `make_unit_square`의 선언 부분이다.

```matlab
classdef rect < handle
    properties
        width (1,1) double {mustBePositive} = 1
        height (1,1) double {mustBePositive} = 1
    end

    methods
        function obj = rect(width, height)
            arguments
                width (1,1) double {mustBePositive} = 3
                height (1,1) double {mustBePositive} = 4
            end
            obj.width = width;
            obj.height = height;
        end

        function make_unit_square(obj)
            obj.width = 1;
            obj.height = 1;
        end
    end
end
```

```matlab
>> a.make_unit_square();
>> a
a = 
  rect with properties:

     width: 1
    height: 1
```

첫 줄에서 rect가 handle을 상속받게 만들었다. 그리고 `make_unit_square`의 반환값이 없다. 사실 반환값은 있어도 되고 없어도 된다. 반환값이 어떤 역할을 하는지는 잠시 뒤에 설명하겠다.

handle을 상속받지 않은 클래스를 value class라고 부른다. Value class는 함수 내부에서 값이 변경되는 순간 인스턴스의 **복사본**이 만들어지면서 값이 변경된다. 사실 클래스가 아니더라도 이러한 동작을 확인할 방법이 있다. 아래 함수를 보자.

```matlab
arr = rand(10000);
get_mean_val(arr);

function get_mean_val(arr)
disp(mean(arr(:)))
end
```

arr이 만들어지는 순간 매트랩의 메모리 점유가 700메가 정도 올라간다. 작업관리자에서 확인 가능하다.

![](https://github.com/keizikang/lazymatlab/blob/master/class_tutorial_tips/%EB%A9%94%EB%AA%A8%EB%A6%AC%20%EC%A6%9D%EA%B0%801.png)
 

768메가 정도 올라갔는데, double 자료형 10,000,000개의 크기와 거의 일치한다. `rand(10000)`을 만들었기 때문이다. 함수 내부로 들어가서 `mean`을 계산해도 메모리는 늘어나지 않는다. `arr`를 바꾸지 않았기 때문이다. 즉, `arr`을 함수 내부에서 바꾸지 않는 한 `arr`는 함수 내외부가 공유한다.

이제 함수에서 `arr`의 값을 바꿔보자.

```matlab
arr = rand(10000);
get_mean_val(arr);

function get_mean_val(arr)
arr(1) = 0;
disp(mean(arr(:)))
end
```

end에 breakpoint를 걸고 작업관리자를 보면, 메모리 점유가 더 늘어난 것을 볼 수 있다.


![](https://github.com/keizikang/lazymatlab/blob/master/class_tutorial_tips/%EB%A9%94%EB%AA%A8%EB%A6%AC%20%EC%A6%9D%EA%B0%802.png)


`arr`의 값을 바꾼 순간, 함수 안에서의 `arr`은 더 이상 함수 외부의 `arr`이 아니다. `arr`의 복사본을 만들고 그 값을 변경한 것이다. 이게 매트랩이 메모리를 관리하는 방식이다.

이와 달리 무조건 함수 내외부가 변수를 공유하는 자료형이 있다. 바로 그래픽 객체이다. 

```matlab
figure, 
h = plot(rand(10,1));
change_color('r')

function change_color(h, color)
h.Color = color;
end
```

위 예제의 경우, `change_color`가 전달받은 `h`의 속성을 바꾼다고 해서 `Line`의 복사본을 만들지 않는다. 함수 내부에서 `gcf`, `gca`, `gco` 등을 쓸 수 있는 것도 모두 같은 원리이다.

맨 처음 만들었던, `classdef rect`로 시작했던 클래스는 value class이다. 따라서 

```matlab
function obj = make_unit_square(obj)
    obj.width = 1;
    obj.height = 1;
end
```

이 메서드에서 `obj`의 속성을 바꾼 순간 `obj`는 우리가 전달한 그 `obj`가 아니게 된다. 그래서 원래 인스턴스는 바뀌지 않는 것이다.

rect가 handle을 상속받으면 rect는 handle class가 된다. handle class는 그래픽 객체와 비슷하게 동작한다. 함수 내부에서 값이나 속성을 바꾸어도 복사본을 만들지 않고 전달된 객체를 직접 바꾼다. 사실 handle class를 함수와 주고받을 때, 실제 객체는 전달되지 않는다. 전달되는 것은 객체의 레퍼런스이다. C언어의 포인터를 생각하면 무슨 말인지 알 것이다.

```matlab
function make_unit_square(obj)
    obj.width = 1;
    obj.height = 1;
end
```

handle 클래스로 만든 rect의 make_unit_square 메서드는 반환값이 필요하지 않다. 어차피 obj를 직접 변경하기 때문이다. 물론 반환값이 있다고 하여 문제될 것은 없다.

```matlab
function obj = make_unit_square(obj)
    obj.width = 1;
    obj.height = 1;
end
```

이 경우 `make_unit_square`는 전달받은 객체의 속성을 바꾼 후 그대로 반환한다. 만약 이 메서드로 객체의 속성을 바꾼 후 다른 함수 또는 메서드에 전달해야 한다면 반환값을 두어야 할 것이다.

### **더 읽기**

https://www.mathworks.com/help/matlab/matlab_oop/comparing-handle-and-value-classes.html 
https://www.mathworks.com/help/matlab/matlab_prog/avoid-unnecessary-copies-of-data.html


---


# **객체의 복사**

퀴즈를 내 보자. 

```matlab
>> a = rect()
a = 
  rect with properties:

               width: 3
              height: 4
>> b = a;
>> a.width = 10;
```

이 상태에서 `b.width`는 얼마일까? 3일까, 10일까?

```matlab
>> b
b = 
  rect with properties:

               width: 10
              height: 4
```

`b.width`는 10이다. 즉, handle class를 다른 변수에 대입하면 둘은 같은 객체를 가리키게 된다. 앞서 말했듯이 handle class의 인스턴스 변수는 사실 인스턴스가 아니라 인스턴스의 레퍼런스를 저장한다. `b = a`를 통해 레퍼런스를 복사한 것이므로 둘은 같은 객체를 가리킨다. 

그렇다면 레퍼런스 복사가 아닌, 정말로 deepcopy를 하는 방법은? 간단하다. `matlab.mixin.Copyable`을 상속받으면 된다. 클래스 선언에서 맨 첫줄만 바꾸면 된다.

```matlab
classdef rect < handle & matlab.mixin.Copyable
```

객체의 복사본은 copy() 함수를 사용하여 만든다.

```matlab
>> a = rect()
a = 
  rect with properties:

               width: 3
              height: 4
>> b = copy(a)
b = 
  rect with properties:

               width: 3
              height: 4
>> a.width = 10;
>> b
b = 
  rect with properties:

               width: 3
              height: 4
```

### **더 읽기**

https://www.mathworks.com/help/matlab/ref/matlab.mixin.copyable-class.html 

---

# **Dependent property와 get method**

rect 클래스로 정의된 직사각형의 면적 area는 width와 height가 있으면 자동으로 정해진다. 따라서 area를 property로 두는 것은 옳지 않다. Area를 property로 두었다가 실수로 바꾸면 width*height가 area와 다른 사태가 발생하기 때문이다. 그렇다면 area를 메서드로 만들면 될 것이다.

```matlab
classdef rect < handle
    properties
        width (1,1) double {mustBePositive} = 1
        height (1,1) double {mustBePositive} = 1
    end

    methods
        function obj = rect(width, height)
            arguments
                width (1,1) double {mustBePositive} = 3
                height (1,1) double {mustBePositive} = 4
            end
            obj.width = width;
            obj.height = height;
        end

        function obj = make_unit_square(obj)
            obj.width = 1;
            obj.height = 1;
        end
        
        function area = area(obj)
            area = obj.width*obj.height;
        end
    end
end
```

```matlab
>> a = rect()
a = 
  rect with properties:

     width: 3
    height: 4
>> a.area
ans =
    12
```

그런데 뭔가 아쉽다. 구현은 메서드로 해두었지만, 의미론적으로 보면 area가 property여야 더 어울린다. 적어도 외부에서 보기에는 area가 property처럼 보였으면 좋겠다. 이럴 때에 area를 클래스의 property들에 의존되어 계산되는 dependent property로 만들면 된다.

Dependent property를 만들기 위해서는 두 가지가 필요하다. 
1.	Property를 만들 때 Dependent라는 attribute를 붙여주어야 한다.
2.	Get method를 반드시 구현해야 한다. Dependent property는 값을 저장하지 않는다. 저장하고 있는 것처럼 보이게 할 뿐이다. 따라서 access 할 때마다 어떤 값을 반환하는 메서드를 반드시 구현해야 하는데, 그게 get method이다.

```matlab
classdef rect < handle
    properties
        width (1,1) double {mustBePositive} = 1
        height (1,1) double {mustBePositive} = 1
    end
    properties (Dependent)
        area
    end

    methods
        function obj = rect(width, height)
            arguments
                width (1,1) double {mustBePositive} = 3
                height (1,1) double {mustBePositive} = 4
            end
            obj.width = width;
            obj.height = height;
        end

        function obj = make_unit_square(obj)
            obj.width = 1;
            obj.height = 1;
        end
        
        function area = get.area(obj)
            area = obj.width*obj.height;
        end
    end
end
```

```
>> a = rect()
a = 
  rect with properties:

     width: 3
    height: 4
      area: 12
>> a.width = 5;
>> a.area
ans =
    20
>>
```

area는 값을 저장하지 않지만 property로 지정되어 있으므로 마치 property처럼 보인다. 그냥 rect의 인스턴스인 a를 보여주기만 해달라고 했는데도 area가 계산되어 표시된다. area도 엄연히 property이므로 a.area로 접근할 수 있다. 물론 area에 접근하는 것은 실제로는 get.area()를 호출하는 것이다.

### **더 읽기**

https://www.mathworks.com/help/matlab/matlab_oop/property-get-methods.html


---

# **Set method**

Get이 property에 access 할 때 호출되는 메서드라면, set은 property의 값을 바꿀 때 호출되는 메서드이다. 예상할 수 있듯이 메서드명은 set.property이다.

rect 클래스에 아래의 두 가지 기능을 추가하고자 한다.

## **기능 1. width와 height에 음수 또는 0을 대입했을 때 예외처리**

rect 클래스의 properties 블록에서 Validation을 통해 width와 height는 양수이도록 제한했다. 0 또는 음수를 넣으면 에러가 발생한다.

```matlab
>> a = rect()
a = 
  rect with properties:

     width: 3
    height: 4
      area: 12
>> a.width = 0
Error setting property 'width' of class 'rect'. Value must be positive.
```

프로그램은 에러가 발생하면 거기에서 실행이 멈춘다. 이것은 우리가 원하는게 아니다. width나 height에 허용되지 않는 값이 입력되면, 경고를 띄워주고 무시했으면 좋겠다. 즉, 예외처리가 필요하다. 그런데 property 값을 바꾸는 데에 어떻게 예외처리를 해줄까? 여기에 필요한 것이 set method이다. 

```matlab
classdef rect < handle
    properties
        width
        height
    end
    properties (Dependent)
        area
    end

    methods
        function obj = rect(width, height)
            arguments
                width (1,1) double {mustBePositive} = 3
                height (1,1) double {mustBePositive} = 4
            end
            obj.width = width;
            obj.height = height;
        end

        function obj = make_unit_square(obj)
            obj.width = 1;
            obj.height = 1;
        end

        function area = get.area(obj)
            area = obj.width*obj.height;
        end

        function set.width(obj, width)
            arguments
                obj
                width (1,1) double
            end
            if width<=0
                warning('Width must be positive')
                return
            end
            obj.width = width;
        end

        function set.height(obj, height)
            arguments
                obj
                height (1,1) double
            end
            if height<=0
                warning('Height must be positive')
                return
            end
            obj.height = height;
        end
    end
end
```

```matlab
>> a = rect()
a = 
  rect with properties:

     width: 3
    height: 4
      area: 12
>> a.width = 0
Warning: Width must be positive 
> In rect/set.width (line 35) 
a = 
  rect with properties:

     width: 3
    height: 4
      area: 12
```

Set method는 항상 입력인자 2개를 받는다. 첫 번째는 set 하려는 객체, 두 번째는 바꾸려는 property의 변경값이다. 위 코드에서 obj는 자기 자신을 가리키게 된다.

Properties 블록에서 Validation을 없앤 것도 주목하자. set method가 호출되면 set method 이전에 Validation을 먼저 확인한다. 우리의 목적은 Validation을 set method 안에서 직접 구현하는 것이다. 

## **기능 2. 사각형의 종횡비 고정 옵션 추가**

경우에 따라 사각형의 종횡비를 고정하고 싶을 수 있다. fix_aspect_ratio라는 property를 만들고, 값이 1이면 width와 height의 비율을 고정하고 싶다. 즉, width를 변경하면 height도 비율에 맞춰 변경되어야 하고 반대의 경우도 동작해야 한다. 여기서 주의할 것이 하나 있다. 아래 코드를 보자.

```matlab
classdef rect < handle
    properties
        width
        height
        fix_aspect_ratio (1,1) logical = 0
    end
    properties (Dependent)
        area
    end

    methods
        function obj = rect(width, height)
            arguments
                width (1,1) double {mustBePositive} = 3
                height (1,1) double {mustBePositive} = 4
            end
            obj.width = width;
            obj.height = height;
        end

        function obj = make_unit_square(obj)
            obj.width = 1;
            obj.height = 1;
        end

        function area = get.area(obj)
            area = obj.width*obj.height;
        end

        function set.width(obj, width)
            arguments
                obj
                width (1,1) double
            end
            if width<=0
                warning('Width must be positive')
                return
            end
            if obj.fix_aspect_ratio
                obj.height = obj.height * width/obj.width;
            end
            obj.width = width;
        end

        function set.height(obj, height)
            arguments
                obj
                height (1,1) double
            end
            if height<=0
                warning('Height must be positive')
                return
            end
            if obj.fix_aspect_ratio
                obj.width = obj.width * height/obj.height;
            end
            obj.height = height;
        end
    end
end
```

별 문제 없어보이는 이 코드의 문제점은 꽤 tricky하다. 

```matlab
>> a = rect()
a = 
  rect with properties:

               width: 3
              height: 4
    fix_aspect_ratio: 0
                area: 12
>> a.fix_aspect_ratio = 1;
>> a.width = 6
Out of memory. The likely cause is an infinite recursion within the program.
Error in rect/set.width (line 40)
                obj.height = obj.height * width/obj.width;
```

왜 recursion 에러가 발생할까? a의 width를 변경하려면 set.width 안으로 들어가야 한다. set.width 안에서 obj.height를 변경하고 있다. 따라서 set.height로 들어간다. set.height 안에서 obj.width를 변경하고 있다. 따라서 다시 set.width로 들어온다. 이 과정이 무한반복되다가 out of memory 에러가 떠버린다.

특별한 기능 추가 없이 해결하는 tricky한 방법이 있다. 

```matlab
function set.width(obj, width)
    arguments
        obj
        width (1,1) double
    end
    if width<=0
        warning('Width must be positive')
        return
    end
    if obj.fix_aspect_ratio
        obj.fix_aspect_ratio = 0;
        obj.height = obj.height * width/obj.width;
        obj.fix_aspect_ratio = 1;
    end
    obj.width = width;
end

function set.height(obj, height)
    arguments
        obj
        height (1,1) double
    end
    if height<=0
        warning('Height must be positive')
        return
    end
    if obj.fix_aspect_ratio
        obj.fix_aspect_ratio = 0;
        obj.width = obj.width * height/obj.height;
        obj.fix_aspect_ratio = 1;
    end
    obj.height = height;
end
```

```matlab
>> a = rect()
a = 
  rect with properties:

               width: 3
              height: 4
    fix_aspect_ratio: 0
                area: 12
>> a.fix_aspect_ratio = 1;
>> a.width = 6
a = 
  rect with properties:

               width: 6
              height: 8
    fix_aspect_ratio: 1
                area: 48
>> a.height = 4
a = 
  rect with properties:

                width: 3
              height: 4
    fix_aspect_ratio: 1
                 area: 12
```

set.width 또는 set.height 안에서 fix_aspect_ratio가 1이면, 우선 0으로 바꾼 후 다른 변수를 바꾸고 와서 자신을 바꾼다. 

R2021b부터는 아예 [괄호, 마침표, 중괄호를 이용한 인덱싱을 재정의](https://www.mathworks.com/help/matlab/customize-object-indexing.html)하는 방법을 제공한다. 이에 대해서는 다른 포스트에서 다룰 예정이다.


---


# **연산자 오버로딩**

```matlab
>> a = rect()
a = 
  rect with properties:

               width: 3
              height: 4
    fix_aspect_ratio: 0
                area: 12
>> b = rect()
b = 
  rect with properties:

               width: 3
              height: 4
    fix_aspect_ratio: 0
                area: 12
```

위의 두 객체는 동일한 객체일까?

```matlab
>> a == b
ans =
  logical
   0
```

아니라고 말한다. 모든 속성이 같으니 ==의 결과가 1이 나와야 할 것이라는 예상은 어디까지나 사람 기준이다. 우리는 컴퓨터에게 "두 rect의 width와 height가 같으면 두 객체는 같아"라고 알려준 적이 없다. 그리고 삐딱한 누군가가 "나는 area만 같으면 같다고 볼건데?" 또는 "나는 둘레의 길이가 같으면 같다고 볼건데?"라고 해도 할 말이 없다. 

따라서 두 rect 객체 간의 연산을 재정의 해줘야 한다. 이걸 유식한 말로 연산자 오버로딩(operator overloading)이라고 부른다. 

```matlab
function tf = eq(obj1, obj2)
    if obj1.width == obj2.width && obj1.height == obj2.height
        tf = true;
    else
        tf = false;
    end
end
```

rect 클래스에 이 함수만 추가하면 두 rect 객체를 비교할 수 있다. width와 height가 같으면 같은 것으로 간주한다. 동작은 각자 확인해보자.

==가 된다면 다른 연산자라고 안될리가 없다. 오버로딩 가능한 연산자 목록과 어떤 메서드를 오버로딩 해야 하는지 잘 정리된 [페이지](https://www.mathworks.com/help/matlab/matlab_oop/implementing-operators-for-your-class.html)가 있으니 확인해보자. 아래는 >, <, >=, <=를 오버로딩한 예시들이다.

```matlab
function tf = gt(obj1, obj2)
    if obj1.width > obj2.width && obj1.height > obj2.height
        tf = true;
    else
        tf = false;
    end
end

function tf = lt(obj1, obj2)
    if obj1.width < obj2.width && obj1.height < obj2.height
        tf = true;
    else
        tf = false;
    end
end

function tf = ge(obj1, obj2)
    if obj1.width >= obj2.width && obj1.height >= obj2.height
        tf = true;
    else
        tf = false;
    end
end

function tf = le(obj1, obj2)
    if obj1.width <= obj2.width && obj1.height <= obj2.height
        tf = true;
    else
        tf = false;
    end
end
```

---

# **내장함수 오버로딩**

내장함수도 오버로딩 할 수 있다. plot()을 통해 rect 클래스를 patch의 형태로 보여주고 싶다면? plot을 재정의하면 된다. 

```matlab
function plot(obj, C)
    arguments
        obj
        C = 'b';
    end
    x = [0, obj.width, obj.width, 0];
    y = [0, 0, obj.height, obj.height];
    patch(x, y, C)
end
```

```matlab
>> a = rect();
>> plot(a)
```
 
 
![](https://github.com/keizikang/lazymatlab/blob/master/class_tutorial_tips/plot(rect).png)

명령창에서 rect 인스턴스를 보여달라고 했을 때

```matlab
>> a
a = 
  rect with properties:

               width: 3
              height: 4
    fix_aspect_ratio: 0
                area: 12
```

이런 형태가 아닌, 새로운 포맷으로 보여주고 싶다면? disp를 재정의하면 된다.

```matlab
function disp(obj)
    disp('  rect(rectangle) class instance')
    disp(' ')
    fprintf('%+20s: %3g\n', 'width', obj.width)
    fprintf('%+20s: %3g\n', 'height', obj.height)
    fprintf('%+20s: %3g\n', 'area', obj.area)
    if obj.fix_aspect_ratio
        fprintf('%+20s: %s\n', 'aspect ratio fixed?', 'true')
    else
        fprintf('%+20s: %s\n', 'aspect ratio fixed?', 'false')
    end
end
```

```matlab
>> a = rect()
a = 
  rect(rectangle) class instance
 
               width:   3
              height:   4
                area:  12
 aspect ratio fixed?: false
```

---

본 글 작성에 도움 주신 매트랩T님, 바이올린소나타 님께 감사 말씀 드립니다.
