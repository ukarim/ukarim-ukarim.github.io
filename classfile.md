# Компилируем класс вручную

_10 янв 2024_

Возьмем для примера следующий класс

```
public final class Test {
  public static void main(String[] args) {
  }
}
```

Попробуем "скомпилировать его вручную", создав class-файл без компилятора javac.

## Об обозначениях

В данной статье будем использовать шеснадцатиричную систему для отображения чисел и массивов байтов.
Общеупотребительного префикса "0x" не будет, это надо иметь ввиду.

Порядок байтов будет big-endian (от старшего к младшему). Поэтому, число 307 будет записано как 0133,
а не 3301. Этот же порядок байтов используется и в самом class-файле (согласно спецификации).

В статье, также будет встречаться следующие обозначения:

- u4 - unsigned 32-bit number (32-битное число без знака)
- u2 - unsigned 16-bit number (16-битное число без знака)
- u1 - unsigned 8-bit number (8-битное число без знака)

## Формат class-файла

Формат class-файла описан в спецификации JVM, которую можно найти по ссылке
[The class File Format](https://docs.oracle.com/javase/specs/jvms/se8/html/jvms-4.html). class-файл можно описать
следующей структурой

```
ClassFile {
  u4             magic;
  u2             minor_version;
  u2             major_version;
  u2             constant_pool_count;
  cp_info        constant_pool[constant_pool_count-1];
  u2             access_flags;
  u2             this_class;
  u2             super_class;
  u2             interfaces_count;
  u2             interfaces[interfaces_count];
  u2             fields_count;
  field_info     fields[fields_count];
  u2             methods_count;
  method_info    methods[methods_count];
  u2             attributes_count;
  attribute_info attributes[attributes_count];
}
```

Поле magic является константой и принимает значение _cafebabe_. Поля minor_version и major_version
указывают на версию данного class-файла. Мы будем пытаться создать class-файл для Java 8. Для данной версии 
java minor_version = 0000 и major_version = 0034.

Тут же, сразу и без дополнительных вычислений можно задать значения для полей: access_flags, interfaces_count,
interfaces, fields_count, fields.

access_flags - поле, указывающее на модификаторы доступа и тип содержимого в class-файле (обычный это класс,
либо enum, interface или аннотация). Данное поле это битовая маска из значений из следующей таблицы

| flag name      | value  | description                                                   |
| ---            | ---    | ---                                                           |
| ACC_PUBLIC     | 0x0001 | public класс                                                  |
| ACC_FINAL      | 0x0010 | final класс                                                   |
| ACC_SUPER      | 0x0020 | для спец. обработки вызова методов родителя при invokespecial |
| ACC_INTERFACE  | 0x0200 | это интерфейс                                                 |
| ACC_ABSTRACT   | 0x0400 | абстрактный класс                                             |
| ACC_SYNTHETIC  | 0x1000 | synthetic; не присутствует в исходниках                       |
| ACC_ANNOTATION | 0x2000 | это аннотация                                                 |
| ACC_ENUM       | 0x4000 | это enum                                                      |

Наш тестовый класс объявлен публичным и финальным, поэтому access_flag = (0001 | 0010) = 0011.

Поля interfaces_count и fields_count будут равны 0000, т.к класс Test не имеет ни интерфейсов, ни
полей класса. А массивы interfaces и fields будут пустыми.

## Constant pool

_constant_pool_ это специальная таблица, хранящая в себе константы, на которые ссылаются остальные части
class-файла. В этой статье для constant pool будет использоваться таблица следующего вида

| constant pool index | value | description |
| ---                 | ---   | ---         |

В колонке value будет находится содержимое constant pool в бинарном виде (в hex формате). Далее в статье
эта таблица будет наполняться различными значениями. Пока она пустая.

Надо отметить, что constant pool индексируется с 1. Поэтому, когда constant pool будет полностью заполнен,
поле _constant_pool_count_ надо будет выставить в значение "количество записей + 1".

## this_class

Данное поле содержит в себе индекс в constant pool, где лежит структура типа

```
CONSTANT_Class_info {
  u1 tag;
  u2 name_index;
}
```

содержащая описание текущего класса. Для данной структуры tag всегда равно значению 7. _name_index_ это индекс
в constant pool, где лежит структура типа

```
CONSTANT_Utf8_info {
  u1 tag;
  u2 length;
  u1 bytes[length];
}
```

, которая хранит в себе название данного класса. _tag_ в CONSTANT_Utf8_info всегда равно 1.
_length_ это длина строки в байтах, а _bytes_ содержит непосредственно строку в виде байтов.

Наш класс называется Test. Для строки "Test" структура CONSTANT_Utf8_info будет выглядеть следующим
образом:

```
CONSTANT_Utf8_info {
  u1 tag = 01         // для CONSTANT_Utf8_info всегда равно 1
  u2 length = 0004    // Строка Test в utf-8 это 4 байта
  u1 bytes = 54657374 // Байты в utf-8
}
```

или в виде hex-строки 01000454657374. А CONSTANT_Class_info для поля this_class будет выглядеть
следующим образом:

```
CONSTANT_Class_info {
  u1 tag        = 07   // для CONSTANT_Class_info всегда равно 7
  u2 name_index = 0001 // структуру для строки Test поместим в constant pool под индексом 1
}
```

В итоге в constant pool добавятся следующие записи

| constant pool index | value          | description                             |
| ---                 | ---            | ---                                     |
| 1                   | 01000454657374 | CONSTANT_Utf8_info для строки Test      |
| 2                   | 070001         | CONSTANT_Class_info для поля this_class |

Поле _this_class_ в class-файле получит значение 0002.

## super_class

Тут все также, как и с _this_class_, только данное поле содержит название родительского класса.
Для класса Test это класс Object. Нужно будет повторить те же процедуры что и для поля _this_class_,
только в этот раз в структуре CONSTANT_Utf8_info будет строка "java/lang/Object". В результате всех
манипуляций в constant pool появится две новых записи

| constant pool index | value                                  | description                                    |
| ---                 | ---                                    | ---                                            |
| 3                   | 0100106a6176612f6c616e672f4f626a656374 | CONSTANT_Utf8_info для строки java/lang/Object |
| 4                   | 070003                                 | CONSTANT_Class_info для поля super_class       |

Поле super_class в итоге получит значение 0004.

## Метод main

Класс Test имеет только один метод - main. Поэтому поле methods_count примет значение 0001. Массив methods
будет содержать одну структуру вида

```
method_info {
  u2             access_flags;
  u2             name_index;
  u2             descriptor_index;
  u2             attributes_count;
  attribute_info attributes[attributes_count];
}
```

Поле access_flag это битовая маска из значений из следующей таблицы

| flag name        | value  | description                                    |
| ---              | ---    | ---                                            |
| ACC_PUBLIC       | 0x0001 |  метод объявлен как public                     |
| ACC_PRIVATE      | 0x0002 |  метод объявлен как private                    |
| ACC_PROTECTED    | 0x0004 |  метод объявлен как protected                  |
| ACC_STATIC       | 0x0008 |  статичный метод                               |
| ACC_FINAL        | 0x0010 |  метод объявлен как final                      |
| ACC_SYNCHRONIZED | 0x0020 |  метод объявлен с synchronized                 |
| ACC_BRIDGE       | 0x0040 |  bridge метод сгенерированный компилятором     |
| ACC_VARARGS      | 0x0080 |  метод с varargs                               |
| ACC_NATIVE       | 0x0100 |  метод объявлен как native                     |
| ACC_ABSTRACT     | 0x0400 |  метод объявлен как abstract                   |
| ACC_STRICT       | 0x0800 |  метод объявлен с strictfp                     |
| ACC_SYNTHETIC    | 0x1000 |  synthetic метод; не присутствует в исходниках |

Метод main объявлен как public static. _access_flag_ будет равен (0001 | 0008) = 0009.

_name_index_ - это индекс в constant pool, который содержит уже знакомую структуру CONSTANT_Utf8_info
с именем метода. Для строки "main" эта структура будет выглядеть как

```
CONSTANT_Utf8_info {
  tag    = 01       // для CONSTANT_Utf8_info всегда равно 1
  length = 0004     // Строка main в utf-8 это 4 байта
  bytes  = 6d61696e // Байты в utf-8
}
```

или в виде hex-строки 0100046d61696e. Эту структуру надо добавить в constant pool

| constant pool index | value          | description                             |
| ---                 | ---            | ---                                     |
| 5                   | 0100046d61696e | CONSTANT_Utf8_info для строки main      |

В итоге, _name_index_ получит значение 0005.

_descriptor_index_ содержит индекс в constant pool, в котором хранится структура CONSTANT_Utf8_info
с описанием метода в формате ({аргументы метода}){возвращаемый тип}. Аргументы и возвращаемый тип метода
должны быть в специальном формате, который можно найти в спецификации в разделе "4.3.3. Method Descriptors".
Для нашего примера {аргументы метода} будет строкой "[Ljava/lang/String;", а {возвращаемый тип} будет
строкой "V". Получается, что в CONSTANT_Utf8_info должна хранится строка "([Ljava/lang/String;)V"

```
CONSTANT_Utf8_info {
  tag    = 01       // для CONSTANT_Utf8_info всегда равно 1
  length = 0016     // Строка ([Ljava/lang/String;)V в utf-8 это 22 байта
  bytes  = 285b4c6a6176612f6c616e672f537472696e673b2956 // Байты в utf-8
}
```

или в ввиде hex-строки 010016285b4c6a6176612f6c616e672f537472696e673b2956. В constant pool появится
новая запись

| constant pool index | value                                              | description                             |
| ---                 | ---                                                | ---                                     |
| 6                   | 010016285b4c6a6176612f6c616e672f537472696e673b2956 | CONSTANT_Utf8_info для descriptor_index |

_descriptor_index_ получит значение 0006.

В _attributes_count_ мы выставим значение 0001, т.к добавим в аттрибуты метода только один аттрибут - Code.
Аттрибут Code будет содержать в себе код метода. Общий вид аттрибута Code следующий

```
Code_attribute {
  u2 attribute_name_index;
  u4 attribute_length;
  u2 max_stack;
  u2 max_locals;
  u4 code_length;
  u1 code[code_length];
  u2 exception_table_length;
  {   u2 start_pc;
      u2 end_pc;
      u2 handler_pc;
      u2 catch_type;
  } exception_table[exception_table_length];
  u2 attributes_count;
  attribute_info attributes[attributes_count];
}
```

attribute_name_index - это ссылка на constant pool, где содержится CONSTANT_Utf8_info с именем аттрибута (в нашем случае
это строка "Code").

```
CONSTANT_Utf8_info {
  tag    = 01       // для CONSTANT_Utf8_info всегда равно 1
  length = 0004     // Строка Code в utf-8 это 4 байта
  bytes  = 436f6465 // Байты в utf-8
}
```

В constant pool попадет новая запись под индексом 7

| constant pool index | value          | description                          |
| ---                 | ---            | ---                                  |
| 7                   | 010004436f6465 | CONSTANT_Utf8_info для строки "Code" |

_attribute_name_index_ будет иметь значение 0007.

Чтобы задать значение для _attribute_length_ необходимо сперва вычислить содержимое остальных полей.

_max_stack_ примет значение 0000, т.к наш метод пустой и не будет использовать стек. А так как в методе будет только одна локальная переменная (аргумент метода), то _max_locals_ примет значение 0001.

Поле _code_ хранит непосредственно инструкции JVM для метода. Наш метод main пустой и ничего не делает, но согласно
спецификации, в список инструкции нужно добавить инструкцию _return = (0xb1)_.

Поля _exception_table_length_ и _attributes_count_ мы выстами в значение 0000, т.к наш метод не содержит try-catch и ссылки на другие аттрибуты.

Учитывая все это, поле _attribute_length_ примет значение 0000000d, а весь аттрибут Code_attribute в бинарном виде
будет выглядеть следующим образом

```
Code_attribute {
  u2 attribute_name_index   = 0007
  u4 attribute_length       = 0000000d
  u2 max_stack              = 0000
  u2 max_locals             = 0001
  u4 code_length            = 00000001
  u1 code                   = b1
  u2 exception_table_length = 0000
  xx exception_table        = 
  u2 attributes_count       = 0000
  attribute_info attributes = 
}
```

В итоге method_info будет иметь следующий вид

```
method_info {
  u2 access_flags           = 0009
  u2 name_index             = 0005
  u2 descriptor_index       = 0006
  u2 attributes_count       = 0001
  attribute_info attributes = 00070000000d0000000100000001b100000000
}
```

а сам class-файл

```
ClassFile {
  magic               = cafebabe
  minor_version       = 0000
  major_version       = 0034
  constant_pool_count = 0008
  constant_pool       = 010004546573740700010100106a6176612f6c616e672f4f626a6563740700030100046d61696e010016285b4c6a6176612f6c616e672f537472696e673b2956010004436f6465
  access_flags        = 0011
  this_class          = 0002
  super_class         = 0004
  interfaces_count    = 0000
  interfaces[interfaces_count] = 
  fields_count        = 0000
  fields = 
  methods_count       = 0001
  methods             = 000900050006000100070000000d0000000100000001b100000000
  attributes_count    = 0000
  attributes = 
}
```

Теперь необходимо создать файл с именем Test.class и записать туда следующий массив байтов:
<p style="word-break: break-word">
cafebabe000000340008010004546573740700010100106a6176612f6c616e672f4f626a6563740700030100046d61696e010016285b4c6a6176612f6c616e672f537472696e673b2956010004436f6465001100020004000000000001000900050006000100070000000d0000000100000001b1000000000000
</p>

## Создание class-файла

### Если есть утилита xxd

Необходимо создать файл Test.txt и записать туда получившуюся hex-строку (см. выше).
Затем надо просто запустить команду:

```
xxd -r -p Test.txt /tmp/Test.class
```

### Если установлена java17

Если у вас установлена Java 17 и выше, то можно просто открыть jshell и выполнить следующие команды:

```
String hexStr = "cafebabe00000034...0000"

java.nio.file.Files.write(java.nio.file.Paths.get("/tmp/Test.class"), java.util.HexFormat.of().parseHex(hexStr))

/exit
```

### Проверка и запуск

```
java -cp /tmp Test
```

Т.к метод main был пустым, то ничего не должно произойти. Программа просто закончит свою работу и все.
Тут главное, чтобы java не выдала ошибку.

Интереснее будет вывод команды javap. Необходимо добавить флаги -v и -c, и утилита распечатает подробную
инфомацию о class-файле:

```
javap -v -c /tmp/Test.class
```
