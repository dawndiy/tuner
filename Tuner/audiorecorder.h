#ifndef AUDIORECORDER_H
#define AUDIORECORDER_H

#include <QObject>
#include <QAudioInput>
#include <QAudioOutput>
#include <QBuffer>

#include "spectrum.h"
#include "spectrumanalyser.h"

class AudioRecorder : public QObject
{
    Q_OBJECT
public:
    explicit AudioRecorder(QObject *parent = 0);

signals:
    /**
     * Spectrum has changed.
     * \param position Position of start of window in bytes
     * \param length   Length of window in bytes
     * \param spectrum Resulting frequency spectrum
     */
    void spectrumChanged(QList<qreal> frequencyList, QList<qreal> amplitudeList);
    void frequencyChanged(qreal frequency);

public slots:
    void record();
    void stop();

private slots:
    void audioNotify();
    void audioStateChanged(QAudio::State state);
    void audioDataReady();
    void spectrumChanged(const FrequencySpectrum &spectrum);

private:
    void setRecordPosition(qint64 position, bool forceEmit = false);
    void calculateSpectrum(qint64 position);

private:
    QAudioFormat        m_audioFormat;

    QAudioInput*        m_audioInput;
    QAudioDeviceInfo    m_audioInputDevice;
    QIODevice*          m_audioInputIODevice;
    qint64              m_recordPosition;

    QByteArray          m_buffer;
    qint64              m_bufferPosition;
    qint64              m_bufferLength;
    qint64              m_dataLength;

    int                 m_spectrumBufferLength;
    QByteArray          m_spectrumBuffer;
    SpectrumAnalyser    m_spectrumAnalyser;
    qint64              m_spectrumPosition;

    int                 m_count;
};

#endif // AUDIORECORDER_H
