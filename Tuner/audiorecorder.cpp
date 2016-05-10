#include <QDebug>
#include <QFile>
#include <QThread>

#include "audiorecorder.h"

//-----------------------------------------------------------------------------
// Constants
//-----------------------------------------------------------------------------

const qint64 BufferDurationUs = 120 * 1000000;
const int    NotifyIntervalMs = 300;

//-----------------------------------------------------------------------------
// Constructor and destructor
//-----------------------------------------------------------------------------

AudioRecorder::AudioRecorder(QObject *parent)
    : QObject(parent)
    , m_audioInput(0)
    , m_audioInputDevice(QAudioDeviceInfo::defaultInputDevice())
    , m_audioInputIODevice(0)
    , m_recordPosition(0)
    , m_bufferPosition(0)
    , m_bufferLength(0)
    , m_dataLength(0)
    , m_spectrumBufferLength(0)
    , m_spectrumAnalyser()
    , m_spectrumPosition(0)
    , m_count(0)
{
    connect(&m_spectrumAnalyser, SIGNAL(spectrumChanged(FrequencySpectrum)),
            this, SLOT(spectrumChanged(FrequencySpectrum)));

    m_buffer.resize(4096);
}

//-----------------------------------------------------------------------------
// Public slots
//-----------------------------------------------------------------------------

void AudioRecorder::record()
{
    qDebug() << "start";

    // Set audio format
    m_audioFormat.setSampleRate(44100);
    m_audioFormat.setChannelCount(1);
    m_audioFormat.setSampleSize(16);
    m_audioFormat.setCodec("audio/pcm");
    m_audioFormat.setByteOrder(QAudioFormat::LittleEndian);
    m_audioFormat.setSampleType(QAudioFormat::SignedInt);

    if (!m_audioInputDevice.isFormatSupported(m_audioFormat)) {
        qDebug() << "Default format not supported, try to use nearset.";
        m_audioFormat = m_audioInputDevice.nearestFormat(m_audioFormat);
    }

    m_count = 0;
    m_spectrumAnalyser.cancelCalculation();

    m_bufferLength = audioLength(m_audioFormat, BufferDurationUs);
    m_buffer.resize(m_bufferLength);

    m_spectrumBufferLength = SpectrumLengthSamples *
                            (m_audioFormat.sampleSize() / 8) * m_audioFormat.channelCount();

    m_audioInput = new QAudioInput(m_audioInputDevice, m_audioFormat, this);
    m_audioInput->setNotifyInterval(NotifyIntervalMs);

    connect(m_audioInput, SIGNAL(stateChanged(QAudio::State)),
            this, SLOT(audioStateChanged(QAudio::State)));
    connect(m_audioInput, SIGNAL(notify()),
            this, SLOT(audioNotify()));

    m_audioInputIODevice = m_audioInput->start();
    connect(m_audioInputIODevice, SIGNAL(readyRead()),
            this, SLOT(audioDataReady()));
}

void AudioRecorder::stop()
{
    qDebug() << "stop";
    m_audioInput->stop();
}

//-----------------------------------------------------------------------------
// Private slots
//-----------------------------------------------------------------------------

void AudioRecorder::audioNotify()
{
    const qint64 recordPosition = qMin(m_bufferLength, audioLength(m_audioFormat, m_audioInput->processedUSecs()));
    setRecordPosition(recordPosition);
    // const qint64 levelPosition = m_dataLength - m_levelBufferLength;
    // if (levelPosition >= 0)
        // calculateLevel(levelPosition, m_levelBufferLength);
    if (m_dataLength >= m_spectrumBufferLength) {
        const qint64 spectrumPosition = m_dataLength - m_spectrumBufferLength;
        calculateSpectrum(spectrumPosition);
    }
    // emit bufferChanged(0, m_dataLength, m_buffer);
}

void AudioRecorder::audioStateChanged(QAudio::State state)
{
    qDebug() << "AudioRecorder::audioStateChanged to" << state;
}

void AudioRecorder::audioDataReady()
{
    Q_ASSERT(0 == m_bufferPosition);
    const qint64 bytesReady = m_audioInput->bytesReady();
    const qint64 bytesSpace = m_buffer.size() - m_dataLength;
    const qint64 bytesToRead = qMin(bytesReady, bytesSpace);

    const qint64 bytesRead = m_audioInputIODevice->read(
                                       m_buffer.data() + m_dataLength,
                                       bytesToRead);

    if (bytesRead) {
        m_dataLength += bytesRead;
        // emit dataLengthChanged(dataLength());
    }

    // qDebug() << "------" << m_buffer.size() << m_dataLength;

    if (m_buffer.size() == m_dataLength) {
        // stop();
        // m_bufferLength = audioLength(m_audioFormat, BufferDurationUs);
        m_buffer.resize(m_bufferLength);
        m_dataLength = 0;
    }


    // qDebug() << "******", m_buffer.size() << m_dataLength;


}

void AudioRecorder::spectrumChanged(const FrequencySpectrum &spectrum)
{
    //qDebug() << "Engine::spectrumChanged" << "pos" << m_spectrumPosition;
    FrequencySpectrum::Element e;
    qreal m = 0;
    qreal p = 0;
    QList<qreal> frequencyList;
    QList<qreal> amplitudeList;
    foreach (e, spectrum) {
        if (e.frequency > 200 && e.frequency < 470) {
            frequencyList.append(e.frequency);
            amplitudeList.append(e.amplitude);
            if (m < e.amplitude) {
                m = e.amplitude;
                p = e.frequency;
            }
        }
    }

    if (m > 0.65) {
        qDebug() << p << m;

        //if (second != c_second) {
            qDebug() << "send";
            emit spectrumChanged(frequencyList, amplitudeList);
            emit frequencyChanged(p);
        //}
    }
}

//-----------------------------------------------------------------------------
// Private functions
//-----------------------------------------------------------------------------

void AudioRecorder::setRecordPosition(qint64 position, bool forceEmit)
{
    m_recordPosition = position;
    // TODO: Emit signal
}

void AudioRecorder::calculateSpectrum(qint64 position)
{
    Q_ASSERT(position + m_spectrumBufferLength <= m_bufferPosition + m_dataLength);
    Q_ASSERT(0 == m_spectrumBufferLength % 2); // constraint of FFT algorithm

    // QThread::currentThread is marked 'for internal use only', but
    // we're only using it for debug output here, so it's probably OK :)
//    qDebug() << "Engine::calculateSpectrum" << QThread::currentThread()
//             << "count" << m_count << "pos" << position << "len" << m_spectrumBufferLength
//             << "spectrumAnalyser.isReady" << m_spectrumAnalyser.isReady();

    if (m_spectrumAnalyser.isReady()) {
        m_spectrumBuffer = QByteArray::fromRawData(m_buffer.constData() + position - m_bufferPosition,
                                                   m_spectrumBufferLength);
        m_spectrumPosition = position;
        m_spectrumAnalyser.calculate(m_spectrumBuffer, m_audioFormat);
    }
}

