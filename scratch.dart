abstract class Step<T> {
  Future<T> execute();
}

abstract class SendInitialPFData {
  Future<void> call(Map<String, String> data);
}

abstract class SendInitialPJData {
  Future<void> call(Map<String, String> data);
}

class SignUpStep implements Step {
  SignUpStep({
    required this.personTypeStep,
    required this.initialDataPFStep,
    required this.initialDataPJStep,
  });

  final PersonTypeStep personTypeStep;
  final InitialDataForPFStep initialDataPFStep;
  final InitialDataForPJStep initialDataPJStep;

  @override
  Future execute() async {
    final personType = await personTypeStep.execute();
    if (personType == 'cpf') {
      await initialDataPFStep.execute();
    } else {
      await initialDataPJStep.execute();
    }
  }
}

class InitialDataForPFStep implements Step {
  InitialDataForPFStep({
    required this.cpfStep,
    required this.emailStep,
    required this.passwordStep,
    required this.sendInitialData,
  });

  final CpfStep cpfStep;
  final EmailStep emailStep;
  final PasswordStep passwordStep;
  final SendInitialPFData sendInitialData;

  @override
  Future<void> execute() async {
    final cpf = await cpfStep.execute();
    final email = await emailStep.execute();
    final password = await passwordStep.execute();
    await sendInitialData(<String, String>{
      'cpf': cpf,
      'email': email,
      'password': password,
    });
  }
}

class InitialDataForPJStep implements Step {
  InitialDataForPJStep({
    required this.emailStep,
    required this.passwordStep,
    required this.dataPJStep,
    required this.sendInitialData,
  });

  final EmailStep emailStep;
  final PasswordStep passwordStep;
  final DataPJStep dataPJStep;
  final SendInitialPJData sendInitialData;

  @override
  Future<void> execute() async {
    final cnpjData = await dataPJStep.execute();
    final email = await emailStep.execute();
    final password = await passwordStep.execute();
    await sendInitialData(<String, String>{
      'email': email,
      'password': password,
      'cnpj': cnpjData.cnpj,
      'type': cnpjData.type,
      'certificate': cnpjData.certificate,
    });
  }
}

class PersonTypeStep implements Step<String> {
  @override
  Future<String> execute() async {
    return 'cnpj';
  }
}

class CpfStep implements Step<String> {
  @override
  Future<String> execute() async {
    return '';
  }
}

class CnpjStep implements Step<String> {
  @override
  Future<String> execute() async {
    return '';
  }
}

class EmailStep implements Step<String> {
  @override
  Future<String> execute() async {
    return '';
  }
}

class PasswordStep implements Step<String> {
  @override
  Future<String> execute() async {
    return '';
  }
}

class CnpjTypeStep implements Step<String> {
  @override
  Future<String> execute() async {
    return '';
  }
}

class CertificateMEStep implements Step<String> {
  @override
  Future<String> execute() async {
    return '';
  }
}

class CertificateLTDAStep implements Step<String> {
  @override
  Future<String> execute() async {
    return '';
  }
}

class DataPJStep implements Step<CnpjData> {
  DataPJStep({
    required this.cnpjStep,
    required this.cnpjTypeStep,
    required this.certificateMEStep,
    required this.certificateLTDAStep,
  });

  final CnpjStep cnpjStep;
  final CnpjTypeStep cnpjTypeStep;
  final CertificateMEStep certificateMEStep;
  final CertificateLTDAStep certificateLTDAStep;

  @override
  Future<CnpjData> execute() async {
    final cnpj = await cnpjStep.execute();
    final type = await cnpjTypeStep.execute();
    late String certificate;
    if (type == 'ME') {
      certificate = await certificateMEStep.execute();
    } else {
      certificate = await certificateLTDAStep.execute();
    }
    return CnpjData(
      cnpj: cnpj,
      type: type,
      certificate: certificate,
    );
  }
}

class CnpjData {
  CnpjData({
    required this.cnpj,
    required this.type,
    required this.certificate,
  });

  final String cnpj;
  final String type;
  final String certificate;
}
